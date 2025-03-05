class MoreAppsModel {
  final bool? status;
  final String? message;
  final List<MoreAppsData>? data;

  MoreAppsModel({
    this.status,
    this.message,
    this.data,
  });

  factory MoreAppsModel.fromJson(Map<String, dynamic> json) => MoreAppsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MoreAppsData>.from(
                json["data"]!.map((x) => MoreAppsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MoreAppsData {
  final int? id;
  final String? image;
  final String? name;
  final String? appLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MoreAppsData({
    this.id,
    this.image,
    this.name,
    this.appLink,
    this.createdAt,
    this.updatedAt,
  });

  factory MoreAppsData.fromJson(Map<String, dynamic> json) => MoreAppsData(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        appLink: json["app_link"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "app_link": appLink,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
