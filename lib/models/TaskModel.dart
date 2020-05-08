import 'dart:convert';

import 'package:flutter/cupertino.dart';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  int id;
  String name;
  String deadlineDate;
  String deadlineTime;
  String description;
  String completedAt;
  bool isPrimary;
  int userId;
  int projectId;
  int categoryId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  TaskModel({
    @required this.id,
    @required this.name,
    @required this.deadlineDate,
    @required this.deadlineTime,
    this.description,
    this.completedAt = '',
    this.isPrimary = false,
    this.userId = 1,
    this.projectId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        name: json["name"],
        deadlineDate: json["deadline_date"],
        deadlineTime: json["deadline_time"],
        description: json["description"],
        completedAt: json["completed_at"],
        isPrimary: json["is_primary"] == 1,
        userId: json["user_id"],
        projectId: json["project_id"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "deadline_date": deadlineDate,
        "deadline_time": deadlineTime,
        "description": description,
        "completed_at": completedAt,
        "is_primary": isPrimary,
        "user_id": userId,
        "project_id": projectId,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
