part of new_product_library;

class NewProduct extends WidgetView<NewProduct, NewProductControllerState> {
  NewProduct(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "New Product",
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {

          if (state is GenerateBarcodeSuccess) {
            controllerState.onBarcodeGenerated(state);
          }
          if(state is AddProductSuccess){
            controllerState.onAddProductSuccess(state);
          }
        },
        builder: (context, state) {
          if (state is LoadingProductUom) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          if (state is LoadProductUomFailure) {
            return Center(child: Text("Failed To Load UOMs"));
          }

          if (state is LoadProductUomSuccess || state is GenerateBarcodeSuccess) {
            // Set default UOM if not already selected
            if (controllerState.selectedUom == null &&
                state is LoadProductUomSuccess &&
                state.response.isNotEmpty) {
              controllerState.selectedUom = state.response.first;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: controllerState.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    /// Product Name Field
                    TextFormField(
                      controller: controllerState.nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Name',
                        border: const OutlineInputBorder(),
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
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Product MRP Field
                    TextFormField(
                      controller: controllerState.priceController,
                      decoration: InputDecoration(
                        labelText: 'Enter Product MRP',
                        border: const OutlineInputBorder(),
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product MRP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Product Base Price Field
                    TextFormField(
                      controller: controllerState.basePriceController,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Base Price',
                        border: const OutlineInputBorder(),
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter base price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Scan Barcode Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controllerState.scanBarcode(context, controllerState.skuController);
                        },
                        child: const Text('Scan Barcode', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Product SKU Field
                    TextFormField(
                      controller: controllerState.skuController,
                      decoration: InputDecoration(
                        labelText: 'Product SKU for/from barcode',
                        border: const OutlineInputBorder(),
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
                    const SizedBox(height: 10),

                    /// Generate Barcode Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controllerState.barcodeImageUrl.isEmpty
                            ? () {
                          controllerState.generateBarcode();
                        }
                            : null,
                        child: const Text('Generate Barcode', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Barcode Display and Download
                    if (state is GenerateBarcodeSuccess || (state is LoadProductUomSuccess && controllerState.barcodeImageUrl != ""))
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                controllerState.barcodeImageUrl,
                                width: 200,
                                height: 100,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Failed to load barcode image");
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await controllerState.downloadBarcodeImage(context);
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Download Barcode"),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),

                    /// UOM Dropdown
                    DropdownButtonFormField<Uom>(
                      decoration: InputDecoration(
                        labelText: 'Select UOM',
                        border: const OutlineInputBorder(),
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
                      value: controllerState.selectedUom,
                      items: state is LoadProductUomSuccess && state.response.isNotEmpty
                          ? state.response.map((Uom uom) {
                        return DropdownMenuItem<Uom>(
                          value: uom.id == 0 ? null : uom,
                          child: Text("${uom.slug} (${uom.title})"),
                        );
                      }).toList()
                          : [],
                      onChanged: (Uom? newValue) {
                        if (newValue != null) {
                          controllerState.updateDropdownItems(newValue);
                        }
                      },
                      validator: (value) {
                        if (value == null) return "Please select a UOM";
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    /// Product Images Upload Section
                    Text("Upload Product Images (min 1)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...controllerState.selectedImages.map((file) {
                          return Stack(
                            children: [
                              Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    controllerState.removeImage(file);
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        InkWell(
                          onTap: () => controllerState.pickImages(context),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo, size: 30),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),


                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controllerState.selectedImages.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select at least one image")),
                            );
                            return;
                          }
                          controllerState.createNewProduct();
                        },
                        child: const Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}