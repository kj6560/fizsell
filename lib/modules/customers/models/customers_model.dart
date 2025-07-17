import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  int id;
  int orgId;
  String customerName;
  String customerAddress;
  String customerPhoneNumber;
  String customerPic;
  int customerActive;
  int customerType;
  String createdAt;
  String updatedAt;

  Customer({
    required this.id,
    required this.orgId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhoneNumber,
    required this.customerPic,
    required this.customerActive,
    required this.customerType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      orgId: int.parse(json["org_id"].toString()),
      customerName: json["customer_name"],
      customerAddress: json["customer_address"],
      customerPhoneNumber: json["customer_phone_number"],
      customerPic: json["customer_pic"] !=null ?json["customer_pic"]:"",
      customerActive: int.parse(json["customer_active"].toString()),
      customerType: int.parse(json['customer_type']),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "org_id": orgId,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "customer_phone_number": customerPhoneNumber,
      "customer_pic": customerPic,
      "customer_active": customerActive,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
