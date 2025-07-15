import 'dart:convert';

List<Currency> currencyFromJson(String str) =>
    List<Currency>.from(json.decode(str).map((x) => Currency.fromJson(x)));

String currencyToJson(List<Currency> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Currency {
  int id;
  String name;            // maps to "name" in JSON
  String code;
  String symbol;
  String country;
  String numericCode;
  int decimalDigits;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Currency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
    required this.country,
    required this.numericCode,
    required this.decimalDigits,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    symbol: json["symbol"],
    country: json["country"],
    numericCode: json["numeric_code"],
    decimalDigits: json["decimal_digits"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "country": country,
    "numeric_code": numericCode,
    "decimal_digits": decimalDigits,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
