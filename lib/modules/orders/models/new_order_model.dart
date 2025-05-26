import 'dart:convert';

import '../../products/models/AppliedScheme.dart';

List<NewOrder> newOrderFromJson(String str) =>
    List<NewOrder>.from(json.decode(str).map((x) => NewOrder.fromJson(x)));

String newOrderToJson(List<NewOrder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewOrder {
  String product_name;
  String sku;
  double quantity;
  double discount;
  double tax;
  double product_mrp;
  List<AppliedScheme> schemes;

  NewOrder(
      {required this.product_name,
      required this.sku,
      required this.quantity,
      required this.discount,
      required this.tax,
      required this.product_mrp,
      required this.schemes});

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
        product_name: json['product_name'],
        product_mrp: json['product_mrp'],
        sku: json['sku'],
        quantity: double.parse(json['quantity'].toString()),
        discount: json['discount'],
        tax: json['tax'],
        schemes: json['schemes']);
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': product_name,
      'sku': sku,
      'quantity': quantity,
      'discount': discount,
      'tax': tax,
      'schemes': schemes
    };
  }
}
