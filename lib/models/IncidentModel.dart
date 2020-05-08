import 'dart:convert';

import 'package:flutter/cupertino.dart';

IncidentModel incidentModelFromJson(String str) =>
    IncidentModel.fromJson(json.decode(str));

String incidentModelToJson(IncidentModel data) => json.encode(data.toJson());

class IncidentModel {
  int id;
  String incidentDate;
  int badHabitId;
  String createdAt;
  String updatedAt;
  String deletedAt;

  IncidentModel({
    @required this.id,
    @required this.incidentDate,
    this.badHabitId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
        id: json["id"],
        incidentDate: json["incident_date"],
        badHabitId: json["bad_habit_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "incident_date": incidentDate,
        "bad_habit_id": badHabitId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
