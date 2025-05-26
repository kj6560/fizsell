// To parse this JSON data, do
//
//     final appContact = appContactFromJson(jsonString);

import 'dart:convert';

List<AppContact> appContactFromJson(String str) => List<AppContact>.from(json.decode(str).map((x) => AppContact.fromJson(x)));

String appContactToJson(List<AppContact> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppContact {
  String name;
  String email;
  String query;
  int queryStatus;
  DateTime queryDate;
  String response;
  DateTime answeredOn;

  AppContact({
    required this.name,
    required this.email,
    required this.query,
    required this.queryStatus,
    required this.queryDate,
    required this.response,
    required this.answeredOn,
  });

  AppContact copyWith({
    String? name,
    String? email,
    String? query,
    int? queryStatus,
    DateTime? queryDate,
    String? response,
    DateTime? answeredOn,
  }) =>
      AppContact(
        name: name ?? this.name,
        email: email ?? this.email,
        query: query ?? this.query,
        queryStatus: queryStatus ?? this.queryStatus,
        queryDate: queryDate ?? this.queryDate,
        response: response ?? this.response,
        answeredOn: answeredOn ?? this.answeredOn,
      );

  factory AppContact.fromJson(Map<String, dynamic> json) => AppContact(
    name: json["name"],
    email: json["email"],
    query: json["query"],
    queryStatus: json["query_status"],
    queryDate: DateTime.parse(json["query_date"]),
    response: json["response"],
    answeredOn: DateTime.parse(json["answered_on"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "query": query,
    "query_status": queryStatus,
    "query_date": queryDate.toIso8601String(),
    "response": response,
    "answered_on": answeredOn.toIso8601String(),
  };
}
