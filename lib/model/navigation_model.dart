class NavigationModel {
  final bool? status;
  final String? message;
  final List<NavigationData>? data;

  NavigationModel({
    this.status,
    this.message,
    this.data,
  });

  factory NavigationModel.fromJson(Map<String, dynamic> json) =>
      NavigationModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NavigationData>.from(
                json["data"]!.map(
                  (x) => NavigationData.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NavigationData {
  final int? id;
  final String? name;
  final String? image;
  final String? type;
  final String? url;
  final String? htmlDetails;
  final String? darkUrl;
  final String? target;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NavigationData({
    this.id,
    this.name,
    this.image,
    this.type,
    this.url,
    this.htmlDetails,
    this.darkUrl,
    this.target,
    this.createdAt,
    this.updatedAt,
  });

  factory NavigationData.fromJson(Map<String, dynamic> json) => NavigationData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        url: json["url"],
        htmlDetails: json["html_details"],
        darkUrl: json["dark_url"],
        target: json["target"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "url": url,
        "html_details": htmlDetails,
        "dark_url": darkUrl,
        "target": target,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
