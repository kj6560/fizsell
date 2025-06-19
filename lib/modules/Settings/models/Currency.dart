// To parse this JSON data, do
//
//     final currency = currencyFromJson(jsonString);

import 'dart:convert';

List<Currency> currencyFromJson(String str) => List<Currency>.from(json.decode(str).map((x) => Currency.fromJson(x)));

String currencyToJson(List<Currency> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Currency {
  int id;
  String country;
  String currency;
  String code;
  int minorUnit;
  dynamic symbol;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Currency({
    required this.id,
    required this.country,
    required this.currency,
    required this.code,
    required this.minorUnit,
    required this.symbol,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    country: json["country"],
    currency: json["currency"],
    code: json["code"],
    minorUnit: json["minor_unit"],
    symbol: json["symbol"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "currency": currency,
    "code": code,
    "minor_unit": minorUnit,
    "symbol": symbol,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
