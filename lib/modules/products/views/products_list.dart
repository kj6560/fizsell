import 'package:fizsell/core/config/base_url.dart';
import 'package:fizsell/core/config/endpoints.dart';
import 'package:fizsell/modules/products/views/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fizsell/core/widgets/base_screen.dart';

import '../../../core/routes.dart';
import '../../../core/widgets/base_widget.dart';
import '../bloc/product_bloc.dart';
import '../models/products_model.dart';
import 'ProductsListController.dart';

class ProductsList
    extends WidgetView<ProductsList, ProductsListControllerState> {
  ProductsList(super.controllerState, {super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Products',
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          print("listener product state is ${state}");
          if (state is ProductSubscriptionFailure) {
            controllerState.changeSubscriptionStatus(false);
          } else if (state is LoadProductSuccess) {
            controllerState.changeSubscriptionStatus(true);
          }
        },
        builder: (context, state) {
          print("product list state: ${state}");
          if (state is LoadingProductList) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 8),
                  Text("Loading"),
                ],
              ),
            );
          } else if (state is LoadProductSuccess) {
            List<Product> allProducts = state.response;
            List<Product> filteredProducts = List.from(allProducts);

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search Products...",
                          prefixIcon: const Icon(Icons.search),
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
                        onChanged: (query) {
                          query = query.toLowerCase();
                          setState(() {
                            if (query.isEmpty) {
                              filteredProducts = List.from(allProducts);
                            } else {
                              filteredProducts =
                                  allProducts.where((product) {
                                    return product.name.toLowerCase().contains(
                                          query,
                                        ) ||
                                        product.sku.toLowerCase().contains(
                                          query,
                                        );
                                  }).toList();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child:
                          filteredProducts.isEmpty
                              ? const Center(child: Text("No products found"))
                              : ListView.builder(
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  Product product = filteredProducts[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.productDetails,
                                        arguments: {"product_id": product.id},
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
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              // 🖼 Product Image
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  (product.images != null &&
                                                          product
                                                              .images
                                                              .isNotEmpty &&
                                                          product
                                                              .images[0]
                                                              .isNotEmpty)
                                                      ? picBaseUrl +
                                                          "/" +
                                                          product.images[0]
                                                      : 'https://via.placeholder.com/80',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // 📄 Product Details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.qr_code,
                                                          size: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "SKU: ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors
                                                                    .grey[800],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            product.sku,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.currency_rupee,
                                                          size: 16,
                                                          color:
                                                              Colors.green[700],
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${product.productMrp}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors
                                                                    .green[800],
                                                          ),
                                                        ),
                                                      ],
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
              },
            );
          } else if (state is ProductSubscriptionFailure) {
            return const Center(
              child: Text(
                "You don't have an active subscription. Plz contact Admin",
              ),
            );
          } else if (state is LoadProductListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(state.error)],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
        },
      ),
      onFabPressed: () {
        print("has subscription: ${controllerState.hasActiveSubscription}");
        if (controllerState.hasActiveSubscription) {
          Navigator.pushNamed(context, AppRoutes.newProduct).then((_) {
            // Re-fetch the product list when coming back
            BlocProvider.of<ProductBloc>(context).add(LoadProductList());
          });
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
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.local_offer, color: Colors.white60),
          onPressed: () {
            if (controllerState.hasActiveSubscription) {
              Navigator.popAndPushNamed(context, AppRoutes.listSchemes);
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
            print("schemes clicked");
          },
        ),
      ],
    );
  }
}
