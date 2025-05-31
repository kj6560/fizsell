import 'dart:io';
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
        BlocProvider<SalesBloc>(
          create: (_) => SalesBloc()..add(const LoadSalesList()),
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
          title: "Home",
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
                      return const Center(child: CircularProgressIndicator());
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
                  child: BlocConsumer<SalesBloc, SalesState>(
                    listener: (context, state) {
                      // Add any side-effects for SalesBloc here
                    },
                    builder: (context, state) {
                      if (state is LoadingSalesList) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LoadSalesSuccess) {
                        return _buildSalesList(
                          state.response,
                        ); // Replace with your actual widget
                      } else if (state is LoadSalesFailure) {
                        return Center(child: Text(state.error));
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<ProductBloc, ProductState>(
                    listener: (context, state) {
                      // You can handle additional product-specific side effects here if needed
                    },
                    builder: (context, state) {
                      if (state is LoadingProductList) {
                        return const Center(child: CircularProgressIndicator());
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
    return Card(
      color: Colors.white60,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            // border added
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          filteredProducts = List.from(products);
                        } else {
                          filteredProducts =
                              products.where((product) {
                                return product.name.toLowerCase().contains(
                                      query,
                                    ) ||
                                    product.sku.toLowerCase().contains(query);
                              }).toList();
                        }
                      });
                    },
                  ),
                ),
              ),
              filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                    itemCount: filteredProducts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalesList(List<SalesModel> allSales) {
    return StatefulBuilder(
      builder: (context, setState) {
        List<SalesModel> filteredSales = List.from(allSales);
        return Container(
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            // border added
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
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text(
                    "Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchSalesController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
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
                        ? const Center(child: Text("No Orders Found"))
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
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order ID: ${order.orderId}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Amount: "),
                                                const Icon(
                                                  Icons.currency_rupee,
                                                  size: 16,
                                                ),
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
