import 'dart:convert';

import 'package:flutter/cupertino.dart';

HabitModel habitModelFromJson(String str) =>
    HabitModel.fromJson(json.decode(str));

String habitModelToJson(HabitModel data) => json.encode(data.toJson());

class HabitModel {
  int id;
  String name;
  String lifetime;
  int frequency;
  String dawn;
  String sunset;
  int userId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  HabitModel({
    @required this.id,
    @required this.name,
    @required this.lifetime,
    this.frequency,
    this.dawn,
    this.sunset,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json["id"],
        name: json["name"],
        lifetime: json["lifetime"],
        frequency: json["frequency"],
        dawn: json["dawn"],
        sunset: json["sunset"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lifetime": lifetime,
        "frequency": frequency,
        "dawn": dawn,
        "sunset": sunset,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
