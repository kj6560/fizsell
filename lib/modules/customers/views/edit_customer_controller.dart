library edit_customer_library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/customers_bloc.dart';
import '../models/customers_model.dart';

part 'edit_customer_screen.dart';

class EditCustomerController extends StatefulWidget {
  const EditCustomerController({super.key});

  @override
  State<EditCustomerController> createState() => EditCustomerControllerState();
}

class EditCustomerControllerState extends State<EditCustomerController> {
  String name = "";
  String email = "";
  int customer_id = 0;
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
    getArguments();
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  void getArguments() {
    print("called");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) {
        print("❌ ModalRoute is NULL. Arguments not passed?");
        return;
      }

      final args = route.settings.arguments;
      if (args == null) {
        print("❌ Arguments are NULL. Check if Navigator is passing arguments.");
        return;
      }

      print("✅ Arguments found: $args");

      if (args is Map<String, dynamic> && args.containsKey("customer_id")) {
        int _customer_id = args["customer_id"];

        setState(() {
          customer_id = _customer_id;
        });
        print("loading product data");
        BlocProvider.of<CustomersBloc>(context)
            .add(LoadCustomer(customer_id: customer_id));
      } else {
        print("❌ Arguments exist but 'sales_id' is missing.");
      }
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerPhoneNumberController = TextEditingController();
  String? selectedValue; // Holds the selected dropdown value
  List<String> dropdownItems = ["Customer Active", "YES", "NO"];
  File? _image;
  Customer? customer;
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

  void updateCustomer() {
    var customer_name = customerNameController.text.trim();
    var customer_address = customerAddressController.text.trim();
    var customer_phone_number = customerPhoneNumberController.text.trim();
    var customer_active = selectedValue == "YES" ? 1 : 0;

    // Use the existing image if no new image is selected
    var customer_image = _image;

    BlocProvider.of<CustomersBloc>(context).add(UpdateCustomer(
      id: customer_id,
      customer_name: customer_name,
      customer_address: customer_address,
      customer_phone_number: customer_phone_number,
      customer_image: customer_image,
      customer_active: customer_active,
      customer_type: int.parse(selectedCustomerType!)
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("editing customer");
    return EditCustomerScreen(this);
  }

  void hasApiResponse(CustomersState state) {
    Navigator.popAndPushNamed(context, AppRoutes.listCustomers);
  }

  void customerUpdate(Customer _customer) {
    setState(() {
      customer = _customer;
      customerNameController.text = customer!.customerName;
      customerAddressController.text = customer!.customerAddress;
      customerPhoneNumberController.text = customer!.customerPhoneNumber;
      selectedValue = customer!.customerActive == 1 ? "YES" : "NO";
      selectedCustomerType = _customer.customerType.toString();
    });
  }
}
