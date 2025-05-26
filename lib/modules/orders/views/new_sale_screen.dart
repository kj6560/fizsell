part of new_sale_library;

class NewSaleScreen extends WidgetView<NewSaleScreen, NewSaleControllerState> {
  NewSaleScreen(super.controllerState, {super.key});

  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseScreen(
      title: "New Sale",

      body: MultiBlocListener(
        listeners: [
          BlocListener<SalesBloc, SalesState>(
            listener: (context, salesState) {
              if (salesState is NewSalesFailure) {
                _showOrderDialog(context, 2);
              } else if (salesState is ProductDetailFetchSuccess) {
                _showQuantityDialog(context, salesState.product);
              }
            },
          ),
          BlocListener<CustomersBloc, CustomersState>(
            listener: (context, customerState) {
              if (customerState is LoadCustomersSuccess &&
                  controllerState.selectedUser == null &&
                  customerState.response.isNotEmpty) {
                controllerState.selectedUser = customerState.response.first;
              }
            },
          ),
        ],
        child: BlocBuilder<SalesBloc, SalesState>(
          builder: (context, salesState) {
            if (salesState is NewSalesSuccess) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New Order Recorded!"),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back'),
                    ),
                  ],
                ),
              );
            }
            return BlocBuilder<CustomersBloc, CustomersState>(
              builder: (context, customerState) {
                if (customerState is LoadingCustomers) {
                  return Center(child: CircularProgressIndicator());
                } else if (customerState is LoadCustomersFailure) {
                  return Center(child: Text("Failed to load customers"));
                } else if (customerState is LoadCustomersSuccess) {
                  return _buildSalesForm(context, customerState.response);
                }
                return Container();
              },
            );
          },
        ),
      ),
      onFabPressed: () async {
        await controllerState.scanBarcode(context,controllerState.skuController);
        if (controllerState.skuController.text != null ) {
          context
              .read<SalesBloc>()
              .add(FetchProductDetail(product_sku: controllerState.skuController.text));
        }
      },
    );
  }

  Widget _buildSalesForm(BuildContext context, List<Customer> customers) {
    return Form(
      key: controllerState.formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Payment Mode',
                border: OutlineInputBorder(),
              ),
              value: controllerState.selectedValue,
              items: controllerState.dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controllerState.updatePaymentMode(newValue);
              },
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<Customer>(
              decoration: InputDecoration(
                labelText: 'Select Customer',
                border: OutlineInputBorder(),
              ),
              value: controllerState.selectedUser,
              items: customers.map((Customer customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: customer.id != 0
                      ? Text(
                          "${customer.customerName}(${customer.customerPhoneNumber})")
                      : Text(customer.customerName),
                );
              }).toList(),
              onChanged: (Customer? selectedCustomer) {
                controllerState.selectedUser = selectedCustomer;
              },
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Products",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controllerState.orders.length,
                itemBuilder: (context, index) {
                  NewOrder newOrder = controllerState.orders[index];
                  List<AppliedScheme> schemes = [];
                  if (newOrder.schemes != null) {
                    schemes = newOrder.schemes;
                  } else {
                    print("scheme not present");
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // changed to align to start
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name column with expanded width and wrapping text
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Product Name"),
                                    Text(
                                      "${newOrder.product_name}",
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (schemes.length > 0)
                                      Column(
                                        children: [
                                          Text(
                                            "${schemes.length} scheme applied",
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                _showSchemeDialog(
                                                    context, schemes);
                                              },
                                              child: Text("See"))
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              // Spacer between name and details
                              const SizedBox(width: 8),
                              // Other info columns
                              Expanded(
                                flex: 3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _infoColumn(
                                          "Qty", "${newOrder.quantity}"),
                                      _infoColumn(
                                          "Mrp", "${newOrder.product_mrp}"),
                                      _infoColumn(
                                          "Disc", "${newOrder.discount}"),
                                      _infoColumn("Tax", "${newOrder.tax}"),
                                      _infoColumn(
                                        "Total",
                                        "${(newOrder.quantity * newOrder.product_mrp - newOrder.discount + newOrder.tax).toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 40,
              child: ElevatedButton(
                onPressed: () => controllerState.submitOrder(),
                child: Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _showQuantityDialog( BuildContext context, Product product) async {
    // Default quantity
    if (_isDialogOpen) return; // Prevent opening multiple dialogs
    _isDialogOpen = true;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        controllerState.resetDialog();
        return AlertDialog(
          title: Text("Fill the details"),
          content: SizedBox(
            height: 230,
            child: Column(
              children: [
                TextField(
                  controller: controllerState.qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: controllerState.discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Discount",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: controllerState.taxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Tax",
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double quantity =
                    double.tryParse(controllerState.qtyController.text) ??
                        1; // Validate input
                double discount =
                    double.parse(controllerState.discountController.text) ??
                        0.0;
                double tax = double.parse(controllerState.taxController.text);
                if (quantity > 0) {
                  NewOrder newOrder = NewOrder(
                      product_name: product.name,
                      product_mrp: product.productMrp,
                      sku: product.sku,
                      quantity: quantity,
                      discount: discount,
                      schemes: product.schemes != null ? product.schemes : [],
                      tax: tax);
                  controllerState.updateOrder(newOrder);
                  print(controllerState.orders.length);
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    ).then((_) {
      _isDialogOpen = false; // Reset flag when dialog is closed
    });
  }

  Future<void> _showOrderDialog(BuildContext context, int type) async {
    // Default quantity

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Order"),
          content: Container(
            child: Column(
              children: [
                Text(type == 1 ? "Order recorded!!" : "Failed To Record Order")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSchemeDialog(
      BuildContext context, List<AppliedScheme> schemes) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Applied Schemes"),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: schemes.length,
              itemBuilder: (context, index) {
                final scheme = schemes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme.schemeName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("Type: ${scheme.schemeType}"),
                      Text("Value: ${scheme.schemeValue}"),
                      if (scheme.bundleProducts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: scheme.bundleProducts.map((bp) {
                              return Text(
                                  "- ${bp.product.name} x${bp.quantity}");
                            }).toList(),
                          ),
                        ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
