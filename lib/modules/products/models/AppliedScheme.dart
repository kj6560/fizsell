import 'dart:convert';

List<AppliedScheme> appliedSchemeFromJson(String str) =>
    List<AppliedScheme>.from(
        json.decode(str).map((x) => AppliedScheme.fromJson(x)));

String appliedSchemeToJson(List<AppliedScheme> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppliedScheme {
  int id;
  String schemeName;
  String schemeType;
  String schemeValue;
  bool isActive;
  String createdAt;
  String updatedAt;
  List<BundleProduct> bundleProducts;

  AppliedScheme({
    required this.id,
    required this.schemeName,
    required this.schemeType,
    required this.schemeValue,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.bundleProducts,
  });

  /// **Factory Method: Convert JSON to `AppliedScheme` Object**
  factory AppliedScheme.fromJson(Map<String, dynamic> json) => AppliedScheme(
        id: json["id"],
        schemeName: json["scheme_name"],
        schemeType: json["scheme_type"],
        schemeValue: json["scheme_value"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        bundleProducts: List<BundleProduct>.from(
            json["bundle_products"].map((x) => BundleProduct.fromJson(x))),
      );

  /// **Method: Convert `AppliedScheme` Object to JSON**
  Map<String, dynamic> toJson() => {
        "id": id,
        "scheme_name": schemeName,
        "scheme_type": schemeType,
        "scheme_value": schemeValue,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "bundle_products":
            List<dynamic>.from(bundleProducts.map((x) => x.toJson())),
      };
}

class BundleProduct {
  int productId;
  int quantity;
  SchemeProduct product;

  BundleProduct({
    required this.productId,
    required this.quantity,
    required this.product,
  });

  factory BundleProduct.fromJson(Map<String, dynamic> json) => BundleProduct(
        productId: json["product_id"],
        quantity: json["quantity"],
        product: SchemeProduct.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
        "product": product.toJson(),
      };
}

class SchemeProduct {
  int id;
  int orgId;
  String name;
  String sku;
  String productMrp;
  int isActive;
  String createdAt;
  String updatedAt;

  SchemeProduct({
    required this.id,
    required this.orgId,
    required this.name,
    required this.sku,
    required this.productMrp,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchemeProduct.fromJson(Map<String, dynamic> json) => SchemeProduct(
        id: json["id"],
        orgId: json["org_id"],
        name: json["name"],
        sku: json["sku"],
        productMrp: json["product_mrp"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "org_id": orgId,
        "name": name,
        "sku": sku,
        "product_mrp": productMrp,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
