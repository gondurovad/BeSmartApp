import 'dart:async';

import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей task

class TaskService {
  TaskService._();

  static final TaskService db = TaskService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(TaskModel item) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM task");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into task ("
        "id,"
        "name,"
        "deadline_date,"
        "deadline_time,"
        "description,"
        "completed_at,"
        "is_primary,"
        "user_id,"
        "project_id,"
        "category_id,"
        "created_at,"
        "updated_at,"
        "deleted_at"
        ") "
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          item.name,
          item.deadlineDate,
          item.deadlineTime,
          item.description,
          item.completedAt,
          item.isPrimary,
          1,
          item.projectId,
          item.categoryId,
          new DateTime.now().toIso8601String(),
          '',
          ''
        ]);
    return raw;
  }

  // Выполнена не выполнена
  checkOrUncheck(TaskModel item) async {
    final db = await database;
    TaskModel model = TaskModel(
        id: item.id,
        name: item.name,
        deadlineDate: item.deadlineDate,
        deadlineTime: item.deadlineTime,
        description: item.description,
        completedAt: item.completedAt == ''
            ? (new DateTime.now().toIso8601String())
            : '',
        isPrimary: item.isPrimary,
        deletedAt: item.deletedAt,
        userId: item.userId,
        projectId: item.projectId,
        categoryId: item.categoryId,
        createdAt: item.createdAt,
        updatedAt: new DateTime.now().toIso8601String());
    var res = await db
        .update("task", model.toJson(), where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  update(TaskModel item) async {
    final db = await database;
    var res = await db
        .update("task", item.toJson(), where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<TaskModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM task WHERE id = ? ORDER BY deadline_date, deadline_time", [id]);
    List<TaskModel> list =
    res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<TaskModel>> getTasksByProjectId(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM task WHERE project_id = ? ORDER BY deadline_date, deadline_time", [id]);
    List<TaskModel> list = res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<TaskModel>> getTasksByCategoryId(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM task WHERE category_id = ? ORDER BY deadline_date, deadline_time", [id]);
    List<TaskModel> list = res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<TaskModel>> getTasksByDeadlineDate(String date) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM task WHERE deadline_date = ? ORDER BY completed_at, is_primary DESC, deadline_time", [date],);
    List<TaskModel> list = res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<TaskModel>> getAll() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM task ORDER BY deadline_date, deadline_time");
    List<TaskModel> list =
        res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<double> getCompletedTasksPercentByProjectId(int id) async {
    final db = await database;
    var completed = await db.rawQuery("SELECT * FROM task WHERE project_id = ? AND completed_at <> '';", [id]);
    var tasks = await db.rawQuery("SELECT * FROM task WHERE project_id = ?;", [id]);
    var percent = tasks.length != 0 && completed.length != 0 ? completed.length / tasks.length : 0.0;
    return percent;
  }

  deleteById(int id) async {
    final db = await database;
    return db.delete("task", where: "id = ?", whereArgs: [id]);
  }

}
