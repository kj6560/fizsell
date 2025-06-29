part of inventory_detail_library;

class InventoryDetailScreen
    extends WidgetView<InventoryDetailScreen, InventoryDetailControllerState> {
  InventoryDetailScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Inventory Detail",
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingInventoryDetail) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          } else if (state is LoadInventoryDetailFailure) {
            return const Center(child: Text("Failed to fetch Details"));
          } else if (state is LoadInventoryDetailSuccess) {
            List<TransactionModel> transactions = state.response.transactions;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: {"product_id": state.response.productId},
                      );
                    },
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              state.response.product.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Product Id: ${state.response.productId}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Balance Quantity",
                              style: TextStyle(fontSize: 16)),
                          Text(
                            "${state.response.balanceQuantity}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Transactions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.teal.shade200)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                    child: Text("Type",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                Expanded(
                                    child: Text("Quantity",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                Expanded(
                                    child: Text("By",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...transactions.map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child:
                                            Text(item.transactionType ?? '-')),
                                    Expanded(child: Text("${item.quantity}")),
                                    Expanded(
                                        child: Text(item.user.name ?? '-')),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
