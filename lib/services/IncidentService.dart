import 'dart:async';
import 'package:besmart/models/IncidentModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей incident

class IncidentService {
  IncidentService._();

  static final IncidentService db = IncidentService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(IncidentModel item) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM incident");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert("INSERT Into incident (id,incident_date, bad_habit_id, created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)",
        [id, item.incidentDate, item.badHabitId, new DateTime.now().toIso8601String(), '', '']);
    return raw;
  }

  Future<List<IncidentModel>> getIncidentsByBadHabitId(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM incident WHERE bad_habit_id = ?", [id]);
    List<IncidentModel> list = res.isNotEmpty ? res.map((c) => IncidentModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<IncidentModel>> getAll() async {
    final db = await database;
    var res = await db.query("incident");
    List<IncidentModel> list = res.isNotEmpty ? res.map((c) => IncidentModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteById(int id) async {
    final db = await database;
    return db.delete("incident", where: "id = ?", whereArgs: [id]);
  }

}