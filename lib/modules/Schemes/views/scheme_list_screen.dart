part of scheme_list_library;

class SchemeListScreen
    extends WidgetView<SchemeListScreen, SchemeListControllerState> {
  SchemeListScreen(super.controllerState, {super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Schemes",
      onFabPressed: () {
        if (controllerState.hasActiveSubscription) {
          Navigator.pushNamed(context, AppRoutes.newScheme).then((_) {
            // Re-fetch the product list when coming back
            controllerState.reset();
          });
        } else {
          showExitConfirmationDialog(context);
        }
      },
      body: BlocConsumer<SchemeBloc, SchemeState>(
        listener: (context, state) {
          // You can add side effects like showing a snackbar here if needed
          if (state is LoadSchemeListSuccess) {
            controllerState.changeSubscriptionStatus(true);
          }
          if (state is SubscriptionFailure) {
            controllerState.changeSubscriptionStatus(false);
          }
        },
        builder: (context, state) {
          print(state);
          if (state is LoadingSchemeList) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 6),
                  Text("Loading"),
                ],
              ),
            );
          } else if (state is LoadSchemeListSuccess) {
            List<Scheme> allSchemes = state.response;
            List<Scheme> filteredSchemes = List.from(allSchemes);

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Schemes',
                          prefixIcon: Icon(Icons.search),
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
                        onChanged: (value) {
                          value = value.toLowerCase();
                          setState(() {
                            filteredSchemes =
                                allSchemes.where((scheme) {
                                  return scheme.schemeName
                                      .toLowerCase()
                                      .contains(value);
                                }).toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child:
                          filteredSchemes.isEmpty
                              ? Center(child: Text("No schemes found"))
                              : ListView.builder(
                                itemCount: filteredSchemes.length,
                                itemBuilder: (context, index) {
                                  final scheme = filteredSchemes[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.schemeDetails,
                                          arguments: {"scheme_id": scheme.id},
                                        ).then((_) {
                                          // Re-fetch the product list when coming back
                                          controllerState.reset();
                                        });
                                        ;
                                      },
                                      child: Card(
                                        elevation: 2,
                                        shadowColor: Colors.black12,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 👕 Product Image
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  (scheme
                                                              .product
                                                              .images
                                                              .isNotEmpty &&
                                                          scheme
                                                              .product
                                                              .images[0]
                                                              .isNotEmpty)
                                                      ? "$picBaseUrl/${scheme.product.images[0]}"
                                                      : 'https://via.placeholder.com/60',
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      width: 60,
                                                      height: 60,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        size: 30,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              // 📝 Scheme Info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      scheme.schemeName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Type: ${scheme.type}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Value: ${scheme.value}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Valid: ${formatDate(scheme.startDate)} → ${formatDate(scheme.endDate)}",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // 🎯 Status
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      scheme.isActive
                                                          ? Colors.green[50]
                                                          : Colors.red[50],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  scheme.isActive
                                                      ? "Active"
                                                      : "Inactive",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        scheme.isActive
                                                            ? Colors.green
                                                            : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  ;
                                },
                              ),
                    ),
                  ],
                );
              },
            );
          } else if (state is SubscriptionFailure) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("Unable to load schemes"));
          }
        },
      ),
    );
  }
}
