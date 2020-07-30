// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

List<ImageModel> imagesFromJson(String str) =>
    List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imagesToJson(List<ImageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  ImageModel({
    this.id,
    this.description,
    this.urls,
    this.user,
  });

  String id;
  dynamic description;
  Urls urls;
  User user;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    id: json["id"],
    description: json["description"],
    urls: Urls.fromJson(json["urls"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "urls": urls.toJson(),
    "user": user.toJson(),
  };
}

class Urls {
  Urls({
    this.full,
    this.thumb,
  });

  String full;
  String thumb;

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    full: json["full"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "full": full,
    "thumb": thumb,
  };
}

class User {
  User({
    this.name,
  });

  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
