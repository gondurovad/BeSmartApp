import 'dart:convert';
import 'package:flutter/cupertino.dart';

BadHabitModel badHabitModelFromJson(String str) =>
    BadHabitModel.fromJson(json.decode(str));

String badHabitModelToJson(BadHabitModel data) => json.encode(data.toJson());

class BadHabitModel {
  int id;
  String name;
  String startAt;
  String completedAt;
  int userId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  BadHabitModel({
    @required this.id,
    @required this.name,
    @required this.startAt,
    this.completedAt,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BadHabitModel.fromJson(Map<String, dynamic> json) => BadHabitModel(
        id: json["id"],
        name: json["name"],
        startAt: json["start_at"],
        completedAt: json["completed_at"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_at": startAt,
        "completed_at": completedAt,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
