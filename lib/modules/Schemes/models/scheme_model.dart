import 'dart:convert';

import '../../products/models/products_model.dart';

List<Scheme> schemeFromJson(String str) =>
    List<Scheme>.from(json.decode(str).map((x) => Scheme.fromJson(x)));

String schemeToJson(List<Scheme> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Scheme {
  final int id;
  final int productId;
  final int orgId;
  final String schemeName;
  final String type;
  final String value;
  final int? duration;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Product> bundleProducts;
  final Product product;

  Scheme({
    required this.id,
    required this.productId,
    required this.orgId,
    required this.schemeName,
    required this.type,
    required this.value,
    this.duration,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.bundleProducts,
    required this.product,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'],
      productId: json['product_id'],
      orgId: json['org_id'],
      schemeName: json['scheme_name'],
      type: json['type'],
      value: json['value'].toString(),
      duration: json['duration'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      bundleProducts: (json['bundle_products'] is List)
          ? (json['bundle_products'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : [], // ✅ Fix: Ensure `bundleProducts` is always a List<Product>
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'org_id': orgId,
      'scheme_name': schemeName,
      'type': type,
      'value': value,
      'duration': duration,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'bundle_products': bundleProducts.map((item) => item.toJson()).toList(),
      'product': product.toJson(),
    };
  }
}
