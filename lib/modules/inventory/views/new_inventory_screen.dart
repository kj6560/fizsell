part of new_inventory_library;

class NewInventoryScreen
    extends WidgetView<NewInventoryScreen, NewInventoryControllerState> {
  NewInventoryScreen(super.controllerState, {super.key});
  final List<String> items = List.generate(200, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseScreen(
        title: "New Inventory",
        body: Container(
          child: Form(
            key: controllerState.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        String? res = await SimpleBarcodeScanner.scanBarcode(
                          context,
                          barcodeAppBar: const BarcodeAppBar(
                            appBarTitle: 'Test',
                            centerTitle: false,
                            enableBackButton: true,
                            backButtonIcon: Icon(Icons.arrow_back_ios),
                          ),
                          isShowFlashIcon: true,
                          delayMillis: 500,
                          cameraFace: CameraFace.back,
                          scanFormat: ScanFormat.ONLY_BARCODE,
                        );
                        print("scan result: ${res}");
                        controllerState.scanBarcode(context,controllerState.skuController,res as String);
                      },
                      child: const Text('Scan Barcode'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerState.skuController,
                      decoration: InputDecoration(
                        labelText: 'Product Sku',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Change this to your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ), // Color when focused
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product SKU is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerState.quantityController,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Quantity',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Change this to your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ), // Color when focused
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        controllerState.createInventory();
                      },
                      child: Text('Submit', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        );
  }
}
