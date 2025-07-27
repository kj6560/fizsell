// To parse this JSON data, do
//
//     final subscriptionOrder = subscriptionOrderFromJson(jsonString);

import 'dart:convert';

SubscriptionOrder subscriptionOrderFromJson(String str) => SubscriptionOrder.fromJson(json.decode(str));

String subscriptionOrderToJson(SubscriptionOrder data) => json.encode(data.toJson());

class SubscriptionOrder {
  int amount;
  int amountDue;
  int amountPaid;
  int attempts;
  int createdAt;
  String currency;
  String entity;
  String orderId;
  dynamic offerId;
  String receipt;
  String status;
  String name;
  String email;
  int userId;
  String contact;

  SubscriptionOrder({
    required this.amount,
    required this.amountDue,
    required this.amountPaid,
    required this.attempts,
    required this.createdAt,
    required this.currency,
    required this.entity,
    required this.orderId,
    required this.offerId,
    required this.receipt,
    required this.status,
    required this.name,
    required this.email,
    required this.userId,
    required this.contact,
  });

  factory SubscriptionOrder.fromJson(Map<String, dynamic> json) => SubscriptionOrder(
    amount: json["amount"],
    amountDue: json["amount_due"],
    amountPaid: json["amount_paid"],
    attempts: json["attempts"],
    createdAt: json["created_at"],
    currency: json["currency"],
    entity: json["entity"],
    orderId: json["order_id"],
    offerId: json["offer_id"],
    receipt: json["receipt"],
    status: json["status"],
    name: json["name"],
    email: json["email"],
    userId: json["user_id"],
    contact: json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "amount_due": amountDue,
    "amount_paid": amountPaid,
    "attempts": attempts,
    "created_at": createdAt,
    "currency": currency,
    "entity": entity,
    "order_id": orderId,
    "offer_id": offerId,
    "receipt": receipt,
    "status": status,
    "name": name,
    "email": email,
    "user_id": userId,
    "contact": contact,
  };
}
