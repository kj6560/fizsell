import 'dart:convert';

import '../../auth/models/User.dart';
import '../../products/models/products_model.dart';

List<InventoryModel> inventoryModelFromJson(String str) =>
    List<InventoryModel>.from(
        json.decode(str).map((x) => InventoryModel.fromJson(x)));

String inventoryModelToJson(List<InventoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InventoryModel {
  int id;
  int orgId;
  int productId;
  double quantity;
  double oldQuantity;
  double balanceQuantity;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;
  List<TransactionModel> transactions;

  InventoryModel({
    required this.id,
    required this.orgId,
    required this.productId,
    required this.quantity,
    required this.oldQuantity,
    required this.balanceQuantity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.transactions,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      orgId: json['org_id'],
      productId: json['product_id'],
      quantity: double.parse(json['quantity'].toString()),
      oldQuantity: json['old_quantity'] != null
          ? double.parse(json['old_quantity'].toString())
          : 0.0,
      balanceQuantity: double.parse(json['balance_quantity'].toString()),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: Product.fromJson(json['product']),
      transactions: json['transactions'] != null
          ? List<TransactionModel>.from(
              json['transactions'].map((x) => TransactionModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'product_id': productId,
      'quantity': quantity,
      'old_quantity': oldQuantity,
      'balance_quantity': balanceQuantity,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'product': product.toJson(),
      'transactions': List<dynamic>.from(transactions.map((x) => x.toJson())),
    };
  }
}

class TransactionModel {
  int id;
  int inventoryId;
  String transactionType;
  double? quantity;
  int transactionBy;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  TransactionModel({
    required this.id,
    required this.inventoryId,
    required this.transactionType,
    required this.quantity,
    required this.transactionBy,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      inventoryId: json['inventory_id'],
      transactionType: json['transaction_type'],
      quantity: json['quantity'] != null
          ? double.tryParse(json['quantity'].toString())
          : null,
      transactionBy: json['transaction_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventory_id': inventoryId,
      'transaction_type': transactionType,
      'quantity': quantity,
      'transaction_by': transactionBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
