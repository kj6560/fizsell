library new_product_library;

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fizsell/core/widgets/base_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_barcode_scanner/barcode_appbar.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../core/widgets/base_screen.dart';
import '../bloc/product_bloc.dart';
import '../models/product_uom.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

part 'new_product.dart';

class NewProductController extends StatefulWidget {
  const NewProductController({super.key});

  @override
  State<NewProductController> createState() => NewProductControllerState();
}

class NewProductControllerState extends State<NewProductController> {
  String _scanBarcode = "";
  Uom? selectedUom;
  List<Uom> dropdownItems = [];
  String barcodeImageUrl = "";

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController basePriceController = TextEditingController();
  List<File> selectedImages = [];
  String savedImagePath = "";

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(LoadProductUom());
  }

  /// Update the UOM list and selected UOM
  void updateUomList(List<Uom> uomList) {
    setState(() {
      dropdownItems = uomList;

      // Set default selected UOM if not already selected
      if (selectedUom == null && dropdownItems.isNotEmpty) {
        selectedUom = dropdownItems.first;
      } else {
        dropdownItems = [
          Uom(id: 0, title: "Select UOM", slug: "", isActive: 1),
        ];
        selectedUom = dropdownItems[0];
      }
    });
  }

  /// Update selected UOM
  void updateDropdownItems(Uom newUom) {
    setState(() {
      selectedUom = newUom;
    });
  }

  /// Create New Product
  void createNewProduct() {
    if (formKey.currentState!.validate()) {
      var name = nameController.text.trim();
      var price = double.tryParse(priceController.text.trim()) ?? 0.0;
      var basePrice = double.tryParse(basePriceController.text.trim()) ?? 0.0;
      var sku = skuController.text.trim();

      if (selectedUom == null || selectedUom!.id == 0) {
        _showSnackbar("Please select a valid UOM");
        return;
      }

      BlocProvider.of<ProductBloc>(context).add(
        AddNewProduct(
          sku: sku,
          name: name,
          price: price,
          base_price: basePrice,
          uom_id: selectedUom!.id,
          selectedImages: selectedImages,
        ),
      );
    }
  }

  /// Scan Barcode

  Future<void> newScanBarcode(
      BuildContext context,
      TextEditingController skuController,
      String result
      ) async {
    if (result.isNotEmpty) {
      skuController.text = result;
    }
  }
  /// Generate Barcode
  void generateBarcode() {
    String sku = skuController.text.trim();
    if (sku.isEmpty) {
      _showSnackbar("SKU cannot be empty for barcode generation.");
      return;
    }

    BlocProvider.of<ProductBloc>(
      context,
    ).add(GenerateBarcode(barcodeValue: sku));
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

  /// Request Storage Permission
  Future<bool> _requestStoragePermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.photos].request();

    return statuses[Permission.storage]?.isGranted == true ||
        statuses[Permission.photos]?.isGranted == true;
  }

  /// Download Image
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (e) {
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
      setState(() {
        savedImagePath = result;
      });
      return result['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => NewProduct(this);

  void onAddProductSuccess(AddProductSuccess state) {
    Navigator.pushReplacementNamed(context, "/list_product");
  }

  Future<void> printBarcode(BuildContext context) async {
    final response = await http.get(Uri.parse(barcodeImageUrl));
    if (response.statusCode != 200) {
      print("Failed to download image");
      return;
    }

    Uint8List imageBytes = response.bodyBytes;

    // Save the file in a shareable location
    final dir = await getExternalStorageDirectory(); // or getTemporaryDirectory()
    final file = File('${dir!.path}/barcode.jpg');
    await file.writeAsBytes(imageBytes);

    final xFile = XFile(file.path, mimeType: 'image/jpeg');

    await Share.shareXFiles(
      [xFile],
      text: 'Print barcode',
      subject: 'Barcode for RawBT',
      sharePositionOrigin: Rect.zero,
    );
  }

}
