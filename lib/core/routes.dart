import 'package:fizsell/modules/Settings/views/currency_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:fizsell/modules/ContactUs/views/contact_us_controller.dart';
import 'package:fizsell/modules/ContactUs/views/contact_us_responses_controller.dart';
import 'package:fizsell/modules/Users/views/new_user_controller.dart';
import 'package:fizsell/modules/Users/views/users_list_controller.dart';
import 'package:fizsell/modules/home/views/home_old.dart';
import 'package:fizsell/modules/home/views/home_controller.dart';
import 'package:fizsell/modules/products/views/ProductsListController.dart';
import 'package:fizsell/modules/products/views/products_list.dart';

import '../modules/Organization/views/create_organization_controller.dart';
import '../modules/Schemes/views/new_scheme_controller.dart';
import '../modules/Schemes/views/scheme_details_controller.dart';
import '../modules/Schemes/views/scheme_list_controller.dart';
import '../modules/Settings/views/settings_controller.dart';
import '../modules/auth/views/login_controller.dart';
import '../modules/customers/views/CustomersListController.dart';
import '../modules/customers/views/edit_customer_controller.dart';
import '../modules/customers/views/new_customer_controller.dart';
import '../modules/home/views/entry.dart';
import '../modules/inventory/views/inventory_detail_controller.dart';
import '../modules/inventory/views/inventory_list_controller.dart';
import '../modules/inventory/views/new_inventory_controller.dart';
import '../modules/orders/views/new_sale_controller.dart';
import '../modules/orders/views/sales_detail_controller.dart';
import '../modules/orders/views/sales_list_controller.dart';
import '../modules/products/views/edit_product_controller.dart';
import '../modules/products/views/new_product_controller.dart';
import '../modules/products/views/product_detail_controller.dart';

class AppRoutes {
  static const String entry = '/entry';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String listInventory = '/list_inventory';
  static const String listProduct = '/list_product';
  static const String listSales = '/list_sales';
  static const String listCustomers = '/list_customers';
  static const String listSchemes = '/list_schemes';
  static const String newProduct = '/new_product';
  static const String editProduct = '/edit_product';
  static const String newSale = '/new_sale';
  static const String newInventory = '/new_Inventory';
  static const String newCustomer = '/new_customer';
  static const String editCustomer = '/edit_customer';
  static const String newScheme = '/new_scheme';
  static const String productDetails = '/product_details';
  static const String salesDetails = '/sales_details';
  static const String inventoryDetails = '/inventory_details';
  static const String schemeDetails = '/scheme_details';
  static const String appSettings = '/settings';
  static const String createOrg = '/createOrganization';
  static const String contactUs = '/contact_us';
  static const String contactUsResponses = '/contact_us_responses';
  static const String userList = '/user_list';
  static const String newUser = '/new_user';
  static const String currencySettings = "/currencySettings";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case entry:
        return MaterialPageRoute(builder: (_) => Entry());
      case login:
        return MaterialPageRoute(builder: (_) => LoginController());
      case home:
        return MaterialPageRoute(builder: (_) => HomeController());
      case listProduct:
        return MaterialPageRoute(builder: (_) => ProductsListController());
      case listSales:
        return MaterialPageRoute(builder: (_) => SalesListController());
      case listCustomers:
        return MaterialPageRoute(builder: (_) => CustomersListController());
      case listInventory:
        return MaterialPageRoute(builder: (_) => InventoryListController());
      case listSchemes:
        return MaterialPageRoute(builder: (_) => SchemeListController());
      case appSettings:
        return MaterialPageRoute(builder: (_) => SettingsController());
      case newProduct:
        return MaterialPageRoute(builder: (_) => NewProductController());
      case editProduct:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return EditProductController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case editCustomer:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return EditCustomerController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case newSale:
        return MaterialPageRoute(builder: (_) => NewSaleController());
      case newCustomer:
        return MaterialPageRoute(builder: (_) => NewCustomerController());
      case newScheme:
        return MaterialPageRoute(builder: (_) => NewSchemeController());
      case newInventory:
        return MaterialPageRoute(builder: (_) => NewInventoryController());
      case salesDetails:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return SalesDetailController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case inventoryDetails:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return InventoryDetailController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case productDetails:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return ProductDetailController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case schemeDetails:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                settings.arguments as Map<String, dynamic>?; // Get arguments
            return SchemeDetailsController(); // Pass arguments if necessary
          },
          settings: settings, // Ensure arguments are attached to the route
        );
      case createOrg:
        return MaterialPageRoute(
          builder: (_) => CreateOrganizationController(),
        );
      case contactUs:
        return MaterialPageRoute(builder: (_) => ContactUsController());
      case contactUsResponses:
        return MaterialPageRoute(
          builder: (_) => ContactUsResponsesController(),
        );
      case userList:
        return MaterialPageRoute(builder: (_) => UsersListController());
      case newUser:
        return MaterialPageRoute(builder: (_) => NewUserController());
      case currencySettings:
        return MaterialPageRoute(builder: (_) => CurrencySettingsController());
      default:
        return MaterialPageRoute(builder: (_) => LoginController());
    }
  }
}
