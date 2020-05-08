import 'dart:convert';

import 'package:flutter/cupertino.dart';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  int id;
  String name;
  String description;
  String completedAt;
  String deadlineAt;
  int userId;
  int categoryId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ProjectModel({
    @required this.id,
    @required this.name,
    this.description,
    this.completedAt,
    @required this.deadlineAt,
    this.userId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        completedAt: json["completed_at"],
        deadlineAt: json["deadline_at"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "completed_at": completedAt,
        "deadline_at": deadlineAt,
        "user_id": userId,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
