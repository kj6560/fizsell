part of new_scheme_library;

class NewSchemeScreen
    extends WidgetView<NewSchemeScreen, NewSchemeControllerState> {
  const NewSchemeScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "New Scheme",
      body: BlocConsumer<SchemeBloc, SchemeState>(
        listener: (context, state) {
          if (state is SchemeCreateSuccess) {
            Navigator.popAndPushNamed(context, AppRoutes.listSchemes);
          }
        },
        builder: (context, state) {
          if (state is LoadProductSuccess) {
            var productList = state.response;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: controllerState._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scheme Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controllerState.schemeNameController,
                          decoration: InputDecoration(
                            labelText: "Scheme Name",
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
                          validator:
                              (value) =>
                                  value!.isEmpty ? "Enter Scheme Name" : null,
                        ),
                      ),

                      // **Main Product Dropdown**
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          value:
                              productList.any(
                                    (product) =>
                                        product.id ==
                                        controllerState.mainProduct,
                                  )
                                  ? controllerState.mainProduct
                                  : null,
                          // ✅ Ensures only valid values are assigned
                          items:
                              productList.map((product) {
                                return DropdownMenuItem<int>(
                                  value: product.id,
                                  child: Text(product.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controllerState.setState(() {
                              controllerState.mainProduct = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Main Product",
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
                          validator:
                              (value) =>
                                  value == null ? "Select Main Product" : null,
                        ),
                      ),

                      // Scheme Type Dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value:
                              [
                                    "combo",
                                    "fixed_discount",
                                    "bogs",
                                  ].contains(controllerState.schemeType)
                                  ? controllerState.schemeType
                                  : null,
                          items:
                              ["combo", "fixed_discount", "bogs"]
                                  .map(
                                    (type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controllerState.setState(() {
                                controllerState.schemeType = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Scheme Type",
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
                        ),
                      ),

                      // Scheme Value
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controllerState.valueController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Value",
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
                          validator:
                              (value) => value!.isEmpty ? "Enter Value" : null,
                        ),
                      ),

                      // Duration (Optional)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controllerState.durationController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Duration (days)",
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
                        ),
                      ),

                      // Start Date Picker
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Start Date: "),
                            TextButton(
                              child: Text(
                                controllerState.startDate == null
                                    ? "Select Date"
                                    : controllerState.startDate
                                        .toString()
                                        .substring(0, 10),
                              ),
                              onPressed: () {
                                controllerState._selectDate(context, true);
                              },
                            ),
                          ],
                        ),
                      ),

                      // End Date Picker
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("End Date: "),
                            TextButton(
                              onPressed: () {
                                controllerState._selectDate(context, false);
                              },
                              child: Text(
                                controllerState.endDate == null
                                    ? "Select Date"
                                    : controllerState.endDate
                                        .toString()
                                        .substring(0, 10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Is Active Checkbox
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text("Is Active"),
                          value: controllerState.isActive,
                          onChanged: (value) {
                            controllerState.setIsActive(value);
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bundle Products Section (Unchanged)
                      Text(
                        "Bundle Products",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children:
                              controllerState.bundleProducts.asMap().entries.map((
                                entry,
                              ) {
                                int index = entry.key;
                                var product = entry.value;

                                return Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        value: product["product_id"],
                                        items:
                                            productList.map((prod) {
                                              return DropdownMenuItem<int>(
                                                value: prod.id,
                                                child: Text(prod.name),
                                              );
                                            }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            controllerState.setState(() {
                                              controllerState
                                                      .bundleProducts[index]["product_id"] =
                                                  value;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Product",
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
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: 40,
                                      child: TextFormField(
                                        initialValue:
                                            product["quantity"].toString(),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Qty",
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
                                        onChanged: (value) {
                                          controllerState
                                                  .bundleProducts[index]["quantity"] =
                                              int.tryParse(value) ?? 1;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => controllerState
                                              .removeBundleProduct(index),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text("Add Bundle Product"),
                          onPressed: controllerState.addBundleProduct,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controllerState.submitForm,
                            child: Text("Submit Scheme"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Column(
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  Center(child: Text("Loading")),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
