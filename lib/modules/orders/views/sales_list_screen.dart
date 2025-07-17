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
                  "You don't have an active subscription. Please contact Admin.",
                ),
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
          } else if (state is LoadSalesSuccess) {
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
                                filteredSales =
                                    allSales.where((sale) {
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
                      child:
                          filteredSales.isEmpty
                              ? Center(child: Text("No Orders Found"))
                              : ListView.builder(
                                itemCount: filteredSales.length,
                                itemBuilder: (context, index) {
                                  SalesModel order = filteredSales[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.salesDetails,
                                        arguments: {"sales_id": order.orderId},
                                      ).then((_) {
                                        // Re-fetch the product list when coming back
                                        controllerState.reset();
                                      });;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: Card(
                                        elevation: 3,
                                        shadowColor: Colors.grey.withOpacity(
                                          0.2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 🆔 Order ID
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Order ID: ${order.orderId}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.receipt_long,
                                                    color: Colors.teal[700],
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              // 💰 Amount & 🕒 Date
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.currency_rupee,
                                                        size: 18,
                                                        color: Colors.green,
                                                      ),
                                                      Text(
                                                        "${order.netTotal}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.calendar_today,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        order.orderDate,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 10),

                                              // Optional: Status or Summary info (if needed)
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.local_shipping,
                                                    size: 16,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Status: ${getStatusText(order.orderStatus)}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
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
          } else if (state is OrderSubscriptionFailure) {
            return const Center(
              child: Text(
                "You don't have an active subscription. Plz contact Admin",
              ),
            );
          } else if (state is LoadSalesFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(state.error)],
              ),
            );
          } else {
            return Container(); // Fallback
          }
        },
      ),
    );
  }
}
