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
          title: "Home",
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Welcome, Keshav 👋",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridItem(
                        Icons.receipt_long,
                        context,
                        "New Order",
                        AppRoutes.newSale,
                      ),
                      _buildGridItem(
                        Icons.inventory,
                        context,
                        "Products",
                        AppRoutes.listProduct,
                      ),
                      _buildGridItem(
                        Icons.people,
                        context,
                        "Customers",
                        AppRoutes.listCustomers,
                      ),
                      _buildGridItem(Icons.bar_chart, context, "Reports", ""),
                    ],
                  ),
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is ForceLogout) {
                      controllerState.forcelogout(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingHome) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      );
                    } else if (state is LoadSuccess) {
                      return _buildDashboardCard(context, state);
                    } else if (state is LoadFailure) {
                      return Center(child: Text(state.error));
                    } else if (state is SubscriptionFailure) {
                      return Center(
                        child: Text(
                          "You don't have an active subscription. Plz contact Admin",
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(
    IconData icon,
    var context,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.teal[700]),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(var context, LoadSuccess state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Card(
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
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Sales",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Total: ₹${state.response.salesData.salesToday}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Invoices: 8 | Customers: 3",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
