library new_customer_library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/customers_bloc.dart';

part 'new_customer_screen.dart';

class NewCustomerController extends StatefulWidget {
  const NewCustomerController({super.key});

  @override
  State<NewCustomerController> createState() => NewCustomerControllerState();
}

class NewCustomerControllerState extends State<NewCustomerController> {
  String name = "";
  String email = "";
  // Controller variables
  String? selectedCustomerType;
  final List<String> customerTypeItems = ['1', '2'];

  void updateCustomerType(String? newType) {
    setState(() {
      selectedCustomerType = newType;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerPhoneNumberController = TextEditingController();
  String? selectedValue; // Holds the selected dropdown value
  List<String> dropdownItems = ["Customer Active", "YES", "NO"];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void updatePaymentMode(String? newValue) {
    setState(() {
      selectedValue = newValue;
    });
  }

  void createNewCustomer() {
    var customer_name = customerNameController.text.trim();
    var customer_address = customerAddressController.text.trim();
    var customer_phone_number = customerPhoneNumberController.text.trim();
    var customer_active = selectedValue == "YES" ? 1 : 0;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Customer Image selected")),
      );

    }

    BlocProvider.of<CustomersBloc>(context).add(NewCustomerCreate(
      customer_name: customer_name,
      customer_address: customer_address,
      customer_phone_number: customer_phone_number,
      customer_image: _image, // safe now
      customer_type: int.parse(selectedCustomerType!),
      customer_active: customer_active,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return NewCustomerScreen(this);
  }

  void hasApiResponse(CustomersState state) {
    Navigator.popAndPushNamed(context, AppRoutes.listCustomers);
  }
}
