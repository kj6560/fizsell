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
                      onPressed: () {
                        controllerState.scanBarcode(context,controllerState.skuController);
                      },
                      child:
                          Text('Scan Barcode', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerState.skuController,
                      decoration: InputDecoration(
                        labelText: 'Product Sku',
                        border: OutlineInputBorder(),
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
