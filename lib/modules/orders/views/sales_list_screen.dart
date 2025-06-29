part of sales_list_library;

class SalesListUi extends WidgetView<SalesListUi, SalesListControllerState> {
  SalesListUi(super.controllerState, {super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Sales",

        onFabPressed: () {
          if (controllerState.hasActiveSubscription) {
            Navigator.pushNamed(context, AppRoutes.newSale).then((_) {
              // Re-fetch the sales list when coming back
              BlocProvider.of<SalesBloc>(context).add(LoadSalesList());
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Subscription Required"),
                  content: Text(
                      "You don't have an active subscription. Please contact Admin."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("OK", style: TextStyle(color: Colors.teal)),
                    ),
                  ],
                );
              },
            );
          }
        },
        body: BlocConsumer<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is LoadSalesFailure) {
              controllerState.changeSubscriptionStatus(false);
            }else if(state is LoadSalesSuccess) {
              controllerState.changeSubscriptionStatus(true);
            }
            // You can add more listeners for other states if needed
          },
          builder: (context, state) {
            if (state is LoadingSalesList) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 8),
                    Text("Loading"),
                  ],
                ),
              );
            } else if (state is LoadSalesSuccess) {
              List<SalesModel> allSales = state.response;
              List<SalesModel> filteredSales = List.from(allSales);

              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search by Order ID',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                              value = value.toLowerCase();
                              setState(() {
                                if (value.isEmpty) {
                                  filteredSales = List.from(allSales);
                                } else {
                                  filteredSales = allSales.where((sale) {
                                    return sale.orderId
                                        .toString()
                                        .toLowerCase()
                                        .contains(value);
                                  }).toList();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: filteredSales.isEmpty
                            ? Center(child: Text("No Orders Found"))
                            : ListView.builder(
                                itemCount: filteredSales.length,
                                itemBuilder: (context, index) {
                                  SalesModel order = filteredSales[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                        context,
                                        AppRoutes.salesDetails,
                                        arguments: {"sales_id": order.orderId},
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Order ID: ${order.orderId}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Amount: "),
                                                      Icon(Icons.currency_rupee,
                                                          size: 16),
                                                      Text("${order.netTotal}"),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${order.orderDate}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              );
            }else if(state is OrderSubscriptionFailure){
              return const Center(
                child: Text("You don't have an active subscription. Plz contact Admin"),
              );
            } else if (state is LoadSalesFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                  ],
                ),
              );
            } else {
              return Container(); // Fallback
            }
          },
        ));
  }
}
