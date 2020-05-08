import 'dart:async';

import 'package:besmart/models/HabitModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

class HabitService {
  HabitService._();

  static final HabitService db = HabitService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(HabitModel item) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM habit");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into habit "
            "(id,"
            "name,"
            "lifetime,"
            "frequency,"
            "dawn,"
            "sunset,"
            "user_id,"
            "created_at,"
            "updated_at,"
            "deleted_at) "
            "VALUES (?,?,?,?,?,?,?,?,?,?)",
        [id, item.name, item.lifetime, item.frequency, item.dawn, item.sunset, 1, new DateTime.now().toIso8601String(), '', '']);
    return raw;
  }

  update(HabitModel item) async {
    final db = await database;
    var res = await db.update("habit", item.toJson(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<HabitModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM habit WHERE id = ?", [id]);
    List<HabitModel> list = res.isNotEmpty ? res.map((c) => HabitModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<HabitModel>> getAll() async {
    final db = await database;
    var res = await db.query("habit");
    List<HabitModel> list = res.isNotEmpty ? res.map((c) => HabitModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteById(int id) async {
    final db = await database;
    return db.delete("habit", where: "id = ?", whereArgs: [id]);
  }

}