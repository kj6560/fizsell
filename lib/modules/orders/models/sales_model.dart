import 'dart:convert';

List<SalesModel> salesModelFromJson(String str) =>
    List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

String salesToJson(List<SalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesModel {
  int orderId;
  int orgId;
  String orderDate;
  int totalOrderValue;
  int totalOrderDiscount;
  int netOrderValue;
  int orderStatus;
  int tax;
  int netTotal;
  int createdBy;
  String orderDetails;
  String print_invoice;

  SalesModel(
      {required this.orderId,
      required this.orgId,
      required this.orderDate,
      required this.totalOrderValue,
      required this.totalOrderDiscount,
      required this.netOrderValue,
      required this.orderStatus,
      required this.tax,
      required this.netTotal,
      required this.createdBy,
      required this.orderDetails,
      required this.print_invoice});

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
        orderId: json['order_id'],
        orgId: json['org_id'],
        orderDate: json['order_date'],
        totalOrderValue: json['total_order_value'],
        totalOrderDiscount: json['total_order_discount'],
        netOrderValue: json['net_order_value'],
        orderStatus: json['order_status'],
        tax: json['tax'],
        netTotal: json['net_total'],
        createdBy: json['created_by'],
        orderDetails: json['order_details'],
        print_invoice: json['print_invoice']);
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'org_id': orgId,
      'order_date': orderDate,
      'total_order_value': totalOrderValue,
      'total_order_discount': totalOrderDiscount,
      'net_order_value': netOrderValue,
      'order_status': orderStatus,
      'tax': tax,
      'net_total': netTotal,
      'created_by': createdBy,
      'order_details': orderDetails,
      'print_invoice': print_invoice
    };
  }
}
