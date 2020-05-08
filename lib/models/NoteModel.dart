import 'dart:convert';

import 'package:flutter/cupertino.dart';

NoteModel notesModelFromJson(String str) =>
    NoteModel.fromJson(json.decode(str));

String notesModelToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
  int id;
  String name;
  String description;
  int userId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  NoteModel({
    @required this.id,
    @required this.name,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
