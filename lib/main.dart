import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fizsell/modules/ContactUs/bloc/contact_us_bloc.dart';
import 'package:fizsell/modules/Users/bloc/user_bloc.dart';
import 'package:fizsell/modules/auth/bloc/auth_bloc.dart';

import 'core/local/hive_Services.dart';
import 'core/routes.dart';
import 'modules/Organization/bloc/organization_bloc.dart';
import 'modules/Schemes/bloc/scheme_bloc.dart';
import 'modules/Settings/bloc/settings_bloc.dart';
import 'modules/customers/bloc/customers_bloc.dart';
import 'modules/home/bloc/home_bloc.dart';
import 'modules/inventory/bloc/inventory_bloc.dart';
import 'modules/orders/bloc/sales_bloc.dart';
import 'modules/products/bloc/product_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  await HiveService.openBoxes();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return AuthBloc();
        }),
        BlocProvider(create: (context) {
          return HomeBloc();
        }),
        BlocProvider(create: (context) {
          return SalesBloc();
        }),
        BlocProvider(create: (context) {
          return InventoryBloc();
        }),
        BlocProvider(create: (context) {
          return ProductBloc();
        }),
        BlocProvider(create: (context) {
          return CustomersBloc();
        }),
        BlocProvider(create: (context) {
          return SchemeBloc();
        }),
        BlocProvider(create: (context) {
          return SettingsBloc();
        }),
        BlocProvider(create: (context) {
          return OrganizationBloc();
        }),
        BlocProvider(create: (context) {
          return ContactUsBloc();
        }),
        BlocProvider(create: (context) {
          return UserBloc();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SwiftSell',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.entry,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
