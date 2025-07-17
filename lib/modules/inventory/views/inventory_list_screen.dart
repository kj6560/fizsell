part of inventory_library;

class InventoryListUi
    extends WidgetView<InventoryListUi, InventoryListControllerState> {
  InventoryListUi(super.controllerState, {super.key});

  final TextEditingController _searchController = TextEditingController();
  List<InventoryModel> filteredInventory = [];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Inventory",
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is LoadInventorySuccess) {
            filteredInventory = List.from(state.response);
            _searchController.clear();
            controllerState.changeSubscriptionStatus(true);
          }
          if (state is LoadInventoryFailure) {
            controllerState.changeSubscriptionStatus(false);
          }
        },
        builder: (context, state) {
          if (state is LoadingInventoryList) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 8),
                  Text("Loading..."),
                ],
              ),
            );
          } else if (state is LoadInventorySuccess) {
            if (filteredInventory.isEmpty && _searchController.text.isEmpty) {
              filteredInventory = List.from(state.response);
            }

            if (filteredInventory.isNotEmpty) {
              return Column(
                children: [
                  // Search Field
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search inventory...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ),
                        ),
                      ),
                      onChanged: (query) {
                        query = query.toLowerCase();
                        if (query.isEmpty) {
                          filteredInventory = List.from(state.response);
                        } else {
                          filteredInventory =
                              state.response.where((inventory) {
                                return inventory.product.name
                                    .toLowerCase()
                                    .contains(query);
                              }).toList();
                        }
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),

                  // Inventory List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredInventory.length,
                      itemBuilder: (context, index) {
                        InventoryModel inventory = filteredInventory[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.inventoryDetails,
                              arguments: {"inventory_id": inventory.id},
                            ).then((_) {
                              // Re-fetch the product list when coming back
                              controllerState.reset();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.inventory_2_outlined,
                                      color: Colors.teal,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            inventory.product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "SKU: ${inventory.product.sku} | Qty: ${inventory.quantity}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (inventory.product.uom != null)
                                            Text(
                                              "UOM: ${inventory.product.uom?.title ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                        ],
                                      ),
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
            }
          } else if (state is InventorySubscriptionFailure) {
            return const Center(
              child: Text(
                "You don't have an active subscription. Please contact Admin",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is LoadInventoryFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.black),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "No Inventory Data Found",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return const Center(
            child: Text(
              "No Inventory Data Found",
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
      onFabPressed: () {
        if (controllerState.hasActiveSubscription) {
          Navigator.pushNamed(context, AppRoutes.newInventory);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Subscription Required"),
                content: const Text(
                  "You don't have an active subscription. Please contact Admin.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
