import 'dart:convert';

List<Subscription> subscriptionFromJson(String str) => List<Subscription>.from(json.decode(str).map((x) => Subscription.fromJson(x)));

String subscriptionToJson(List<Subscription> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subscription {
  int featureId;
  String featureName;
  String featurePrice;
  String details;

  Subscription({
    required this.featureId,
    required this.featureName,
    required this.featurePrice,
    required this.details,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    featureId: json["feature_id"],
    featureName: json["feature_name"],
    featurePrice: json["feature_price"],
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "feature_id": featureId,
    "feature_name": featureName,
    "feature_price": featurePrice,
    "details": details,
  };
}