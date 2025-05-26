import 'dart:convert';

List<Uom> uomFromJson(String str) =>
    List<Uom>.from(json.decode(str).map((x) => Uom.fromJson(x)));

String uomToJson(Uom data) => json.encode(data.toJson());

class Uom {
  int id;
  String title;
  String slug;
  int isActive;

  Uom({
    required this.id,
    required this.title,
    required this.slug,
    required this.isActive,
  });

  factory Uom.fromJson(Map<String, dynamic> json) => Uom(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "is_active": isActive,
  };

  // Override == operator to compare Uom objects based on id
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Uom && id == other.id;

  // Override hashCode to ensure consistency with ==
  @override
  int get hashCode => id.hashCode;
}
