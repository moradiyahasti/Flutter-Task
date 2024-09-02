import 'dart:convert';

List<GetApiList> getApiListFromJson(String str) =>
    List<GetApiList>.from(json.decode(str).map((x) => GetApiList.fromJson(x)));

String getApiListToJson(List<GetApiList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetApiList {
  int userId;
  int id;
  String title;
  String body;

  GetApiList({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory GetApiList.fromJson(Map<String, dynamic> json) => GetApiList(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
