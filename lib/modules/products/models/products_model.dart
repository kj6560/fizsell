import 'dart:convert';

import 'package:fizsell/modules/products/models/product_uom.dart';

import 'AppliedScheme.dart';
List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int id;
  int orgId;
  String name;
  String sku;
  double productMrp;
  double? basePrice;
  int isActive;
  List<String> images;
  String createdAt;
  String updatedAt;
  ProductPrice? price;
  Uom? uom;
  List<AppliedScheme> schemes;

  Product({
    required this.id,
    required this.orgId,
    required this.name,
    required this.sku,
    required this.productMrp,
    required this.isActive,
    required this.basePrice,
    required this.images,
    this.createdAt = "",
    this.updatedAt = "",
    required this.price,
    required this.uom,
    required this.schemes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      orgId: json['org_id'],
      name: json['name'],
      sku: json['sku'].toString(),
      productMrp: double.parse(json['product_mrp'].toString()),
      basePrice: json['base_price'] != null
          ? double.tryParse(json['base_price'].toString())
          : null,
      isActive: json['is_active'],
      images: (json['images'] is List)
          ? List<String>.from(json['images'])
          : [],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      price:
          json['price'] != null ? ProductPrice.fromJson(json['price']) : null,
      uom: json['uom'] != null ? Uom.fromJson(json['uom']) : null,
      schemes: json['schemes'] != null
          ? List<AppliedScheme>.from(
              json['schemes'].map((x) => AppliedScheme.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'name': name,
      'sku': sku,
      'product_mrp': productMrp,
      'base_price': basePrice,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'price': price?.toJson(),
      'uom': uom?.toJson(),
      'images': images,
      'schemes': schemes != null
          ? List<dynamic>.from(schemes.map((x) => x.toJson()))
          : [],
    };
  }
}

class ProductPrice {
  int? id;
  int? productId;
  double? price;
  int? uomId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  ProductPrice({
    this.id,
    this.productId,
    this.price,
    this.uomId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      id: json['id'],
      productId: json['product_id'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      uomId: json['uom_id'],
      isActive: json['is_active'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'price': price,
      'uom_id': uomId,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
