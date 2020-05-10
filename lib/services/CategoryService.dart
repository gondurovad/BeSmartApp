import 'dart:async';

import 'package:besmart/models/CategoryModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей category

class CategoryService {
  CategoryService._();

  static final CategoryService db = CategoryService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(CategoryModel item) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM category");
    int id = table.first["id"];
    var raw = await db.rawInsert("INSERT Into category (id,name,user_id,created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)",
        [id, item.name, 1, new DateTime.now().toIso8601String(), '', '']);
    return raw;
  }

  update(CategoryModel item) async {
    final db = await database;
    var res = await db.update("category", item.toJson(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<CategoryModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM category WHERE id = ?", [id]);
    List<CategoryModel> list = res.isNotEmpty ? res.map((c) => CategoryModel.fromJson(c)).toList() : [];
    return list;
  }


  Future<List<CategoryModel>> getAll() async {
    final db = await database;
    var res = await db.query("category");
    List<CategoryModel> list = res.isNotEmpty ? res.map((c) => CategoryModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteById(int id) async {
    final db = await database;
    await db.rawUpdate("UPDATE project SET category_id = null WHERE category_id=?", [id]);
    await db.rawUpdate("UPDATE task SET category_id = null WHERE category_id=?", [id]);
    return db.rawDelete("DELETE FROM category WHERE id=?",[id]);
  }
}