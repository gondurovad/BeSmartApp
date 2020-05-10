import 'dart:async';

import 'package:besmart/models/BadHabitModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей bad_habit

class BadHabitService {

  BadHabitService._();

  static final BadHabitService db = BadHabitService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(BadHabitModel item) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM bad_habit");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into bad_habit "
        "(id,name,start_at,completed_at,"
        "user_id,created_at,updated_at,deleted_at) "
        "VALUES (?,?,?,?,?,?,?,?)",
        [id, item.name, item.startAt, '', 1, new DateTime.now().toIso8601String(), '', '']);
    return raw;
  }

  update(BadHabitModel item) async {
    final db = await database;
    var res = await db.update("bad_habit", item.toJson(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  // Завершить вредную привычку
  complete(BadHabitModel item) async {
    final db = await database;
    BadHabitModel model = BadHabitModel(
        id: item.id,
        name: item.name,
        startAt: item.startAt,
        completedAt: new DateTime.now().toIso8601String(),
        userId: item.userId,
        createdAt: item.createdAt,
        updatedAt: new DateTime.now().toIso8601String(),
        deletedAt: '');
    var res = await db.update("bad_habit", model.toJson(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  // Активировать вредную привычку
  activate(BadHabitModel item) async {
    final db = await database;
    db.rawDelete("DELETE FROM incident WHERE bad_habit_id = ?;", [item.id]);
    BadHabitModel model = BadHabitModel(
        id: item.id,
        name: item.name,
        startAt: new DateTime.now().toIso8601String(),
        completedAt: '',
        userId: item.userId,
        createdAt: item.createdAt,
        updatedAt: new DateTime.now().toIso8601String(),
        deletedAt: '');
    var res = await db.update("bad_habit", model.toJson(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<BadHabitModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM bad_habit WHERE id = ?", [id]);
    List<BadHabitModel> list = res.isNotEmpty
        ? res.map((c) => BadHabitModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<BadHabitModel>> getAll() async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT * FROM bad_habit ORDER BY created_at DESC");
    List<BadHabitModel> list = res.isNotEmpty
        ? res.map((c) => BadHabitModel.fromJson(c)).toList()
        : [];
    return list;
  }

  deleteById(int id) async {
    final db = await database;
    db.rawDelete("DELETE FROM incident WHERE bad_habit_id = ?;", [id]);
    return db.rawDelete("DELETE FROM bad_habit WHERE id = ?;", [id]);
  }
}
