import 'dart:io';
import 'package:fizsell/core/config/AppConstants.dart';
import 'package:fizsell/modules/orders/bloc/sales_bloc.dart';
import 'package:fizsell/modules/orders/models/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/base_url.dart';
import '../../../core/routes.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../../core/widgets/exit_confirmation.dart';
import '../../products/bloc/product_bloc.dart';
import '../../products/models/products_model.dart';
import '../bloc/home_bloc.dart';
import 'home_controller.dart';

class HomePage extends WidgetView<HomePage, HomeControllerState> {
  HomePage(super.controllerState);

  final TextEditingController _searchProductsController =
      TextEditingController();
  final TextEditingController searchSalesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(const HomeLoad()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc()..add(const LoadProductList()),
        ),

      ],
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          bool exitApp = await _onBackPressed(context);
          if (exitApp) {
            Navigator.of(context).pop();
          }
        },
        child: BaseScreen(
          title: AppConstants.appName,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is ForceLogout) {
                      controllerState.forcelogout(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingHome) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red,));
                    } else if (state is LoadSuccess) {
                      return _buildDashboardCard(state);
                    } else if (state is LoadFailure) {
                      return Center(child: Text(state.error));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(
                    child: Text(
                      "Products",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: BlocConsumer<ProductBloc, ProductState>(
                    listener: (context, state) {
                      // You can handle additional product-specific side effects here if needed
                    },
                    builder: (context, state) {
                      if (state is LoadingProductList) {
                        return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                      } else if (state is LoadProductSuccess) {
                        return _buildProductList(state.response);
                      } else if (state is LoadProductListFailure) {
                        return Center(child: Text(state.error));
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(LoadSuccess state) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        child: Card(
          elevation: 1,
          shadowColor: Color(0xFFB5A13F),
        // border added,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn("Time", ["", "Today", "Monthly", "Total"]),
                _buildColumn("Products", [
                  "",
                  "${state.response.productsData.productsAddedToday}",
                  "${state.response.productsData.productsAddedThisMonth}",
                  "${state.response.productsData.productsAddedTotal}",
                ]),
                _buildColumn("Inventory", [
                  "",
                  "${state.response.inventoryData.inventoryAddedToday}",
                  "${state.response.inventoryData.inventoryAddedThisMonth}",
                  "${state.response.inventoryData.inventoryAddedTotal}",
                ]),
                _buildColumn("Sales", [
                  "",
                  "₹${state.response.salesData.salesToday}",
                  "₹${state.response.salesData.salesThisMonth}",
                  "₹${state.response.salesData.salesTotal}",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(String title, List<String> values) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          for (var val in values.skip(1)) ...[
            const SizedBox(height: 12),
            Text(val),
          ],
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    List<Product> filteredProducts = List.from(products);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB5A13F), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // 🔍 Search Box
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchProductsController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search by Order ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFB5A13F)),
                    ),
                  ),
                  onChanged: (query) {
                    query = query.toLowerCase();
                    setState(() {
                      filteredProducts = query.isEmpty
                          ? List.from(products)
                          : products.where((product) {
                        return product.name
                            .toLowerCase()
                            .contains(query) ||
                            product.sku
                                .toLowerCase()
                                .contains(query);
                      }).toList();
                    });
                  },
                ),
              ),

              // 📦 Product List View (max 3 visible, scrollable)
              filteredProducts.isEmpty
                  ? const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(child: Text("No products found")),
              )
                  : SizedBox(
                height: 3 * 115.0, // Approx height for 3 cards
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetails,
                          arguments: {"product_id": product.id},
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    (product.images != null &&
                                        product.images.isNotEmpty &&
                                        product.images[0].isNotEmpty)
                                        ? "$picBaseUrl/${product.images[0]}"
                                        : 'https://via.placeholder.com/80',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Product Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.qr_code,
                                            size: 16,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "SKU: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              product.sku,
                                              overflow: TextOverflow.ellipsis,
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
                                            color: Colors.green[700],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${product.productMrp}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[800],
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
          ),
        );
      },
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          ),
    );

    if (exitApp == true) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }

    return false;
  }
}
