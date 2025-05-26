library edit_product_controller;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/product_bloc.dart';
import '../models/product_uom.dart';
import '../models/products_model.dart';

part 'edit_product_screen.dart';

class EditProductController extends StatefulWidget {
  const EditProductController({super.key});

  @override
  State<EditProductController> createState() => EditProductControllerState();
}

class EditProductControllerState extends State<EditProductController> {
  String _scanBarcode = "";
  Uom? selectedUom;
  List<Uom> dropdownItems = [];
  String name = "";
  String email = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController basePriceController = TextEditingController();
  String barcodeImageUrl = "";
  List<File> selectedImages = [];

  Future<void> pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 80);
    if (pickedFiles != null) {
      setState(() {
        selectedImages.addAll(pickedFiles.map((x) => File(x.path)));
      }); // or call setState if using StatefulWidget
    }
  }
  void removeImage(File file) {
    selectedImages.remove(file);
    setState(() {
      selectedImages.remove(file);
    });
  }
  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  void updateDropdownItems(List<Uom> newUom) {
    print("Dropdown Items: ${dropdownItems.map((e) => e.title).toList()}");

    setState(() {
      dropdownItems = newUom;
    });
  }

  void updateProduct() {
    if (formKey.currentState!.validate()) {
      var name = nameController.text.toString();
      var price = priceController.text.toString();
      var base_price = basePriceController.text.toString();
      var sku = skuController.text.toString();

      BlocProvider.of<ProductBloc>(context).add(
        AddNewProduct(
            sku: sku,
            name: name,
            price: double.tryParse(price)!,
            base_price: double.parse(base_price)!,
            uom_id: selectedUom!.id,
            selectedImages: selectedImages
        ),
      );
      Navigator.popAndPushNamed(context, "/home");
    }
  }


  /// Scan Barcode
  Future<void> scanBarcode(BuildContext context, TextEditingController skuController) async {
    String barcodeScanRes = '';

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Scan Barcode")),
          body: MobileScanner(
            onDetect: (barcodeCapture) {
              final Barcode? barcode = barcodeCapture.barcodes.first;
              if (barcode?.rawValue != null) {
                barcodeScanRes = barcode!.rawValue!;
                Navigator.pop(context, barcodeScanRes);
              }
            },
          ),
        ),
      ),
    );

    if (barcodeScanRes.isNotEmpty) {
      skuController.text = barcodeScanRes;
    }
  }

  /// Generate Barcode
  void generateBarcode() {
    String sku = skuController.text.trim();
    if (sku.isEmpty) {
      _showSnackbar("SKU cannot be empty for barcode generation.");
      return;
    }

    BlocProvider.of<ProductBloc>(context).add(GenerateBarcode(barcodeValue: sku));
  }

  /// Handle Barcode Generation Success
  void onBarcodeGenerated(GenerateBarcodeSuccess state) {
    setState(() {
      barcodeImageUrl = state.barcodeUrl;
    });
    BlocProvider.of<ProductBloc>(context).add(LoadProductUom());
  }

  /// Download Barcode Image
  Future<void> downloadBarcodeImage(BuildContext context) async {
    try {
      if (!await _requestStoragePermission()) {
        _showSnackbar("Storage permission denied.");
        return;
      }

      Uint8List? imageBytes = await _downloadImage(barcodeImageUrl);
      if (imageBytes == null) {
        _showSnackbar("Failed to download image.");
        return;
      }

      if (await _saveImageToGallery(imageBytes)) {
        _showSnackbar("Barcode downloaded successfully!");
      } else {
        _showSnackbar("Failed to save barcode image.");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }



  /// Download Image
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.bodyBytes as Uint8List?;
      } else {
        print('❌ Failed to download image. Status code: ${response.statusCode}');
        return null;
      }
    } on http.ClientException catch (e) {
      print('❌ ClientException: $e');
      return null;
    } on Exception catch (e) {
      print('❌ Exception occurred: $e');
      return null;
    }
  }

  /// Save Image to Gallery
  Future<bool> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 80,
        name: "barcode_${DateTime.now().millisecondsSinceEpoch}",
      );
      return result['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    if (await Permission.photos.request().isGranted) {
      return true;
    }

    return false;
  }

  void populateProductDetails(Product product) {
    nameController.text = product.name;
    priceController.text = product.productMrp.toString();
    basePriceController.text = product.basePrice.toString();
    skuController.text = product.sku;
    if (dropdownItems.isNotEmpty) {
      selectedUom = dropdownItems.firstWhere(
        (uom) => uom.id == product.uom!.id,
        orElse: () => dropdownItems.first,
      );
    }
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

      if (args is Map<String, dynamic> && args.containsKey("product_id")) {
        String product_id = args["product_id"];

        setState(() {
          product_id = product_id;
        });
        print("loading product data");
        BlocProvider.of<ProductBloc>(context)
            .add(LoadProductDetail(product_id: product_id.toString()));
      } else {
        print("❌ Arguments exist but 'sales_id' is missing.");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
    BlocProvider.of<ProductBloc>(context).add(LoadProductUom());
  }

  @override
  Widget build(BuildContext context) {
    return EditProductScreen(this);
  }

  void updateUom(Uom first) {
    setState(() {
      selectedUom = first;
    });
  }

  void loadProductDetails() {
    getArguments();
  }
}
