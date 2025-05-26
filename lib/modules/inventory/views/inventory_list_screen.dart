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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 8),
                  Text("Loading..."),
                ],
              ),
            );
          }
          else if (state is LoadInventorySuccess) {
            // Populate filteredInventory only once
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
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (query) {
                        query = query.toLowerCase();
                        if (query.isEmpty) {
                          filteredInventory = List.from(state.response);
                        } else {
                          filteredInventory = state.response.where((inventory) {
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
                            Navigator.popAndPushNamed(
                              context,
                              AppRoutes.inventoryDetails,
                              arguments: {"inventory_id": inventory.id},
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(inventory.product.name),
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
          }
          else if (state is LoadInventoryFailure) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          else {
            return Center(
              child: Text(
                "No Inventory Data Found",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return Center(
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
    );
  }
}
