import 'dart:async';

import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей project

class ProjectService {
  ProjectService._();

  static final ProjectService db = ProjectService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(ProjectModel item) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM project");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into project "
            "(id,name,description,completed_at,"
            "deadline_at,user_id,category_id,created_at,updated_at,deleted_at) "
            "VALUES (?,?,?,?,?,?,?,?,?,?)",
        [id, item.name, item.description, item.completedAt, item.deadlineAt, 1, item.categoryId, new DateTime.now().toIso8601String(), '', '']);
    return raw;
  }

  update(ProjectModel item) async {
    final db = await database;
    var res = await db.update("project", item.toJson(), where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<ProjectModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM project WHERE id = ? ORDER BY deadline_at", [id]);
    List<ProjectModel> list = res.isNotEmpty ? res.map((c) => ProjectModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ProjectModel>> getProjectsByCategoryId(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM project WHERE category_id = ? ORDER BY deadline_at", [id]);
    List<ProjectModel> list = res.isNotEmpty ? res.map((c) => ProjectModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ProjectModel>> getAll() async {
    final db = await database;
    var res = await db.query("project", orderBy: "deadline_at");
    List<ProjectModel> list = res.isNotEmpty ? res.map((c) => ProjectModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteById(int id) async {
    final db = await database;
    db.rawDelete("DELETE FROM task WHERE project_id = ?;", [id]);
    return db.rawDelete("DELETE FROM project WHERE id = ?;", [id]);
  }

}
