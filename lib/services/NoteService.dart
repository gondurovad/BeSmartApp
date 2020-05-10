import 'dart:async';

import 'package:besmart/models/NoteModel.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за взаимодействие с таблицей note

class NoteService {
  NoteService._();

  static final NoteService db = NoteService._();

  Future<Database> get database async {
    return await DatabaseService.init();
  }

  create(NoteModel item) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM notes");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into note ("
            "id,"
            "name,"
            "description,"
            "user_id,"
            "created_at,"
            "updated_at,"
            "deleted_at"
            ") "
            "VALUES (?,?,?,?,?,?,?)",
        [
          id,
          item.name,
          item.description,
          1,
          new DateTime.now().toIso8601String(),
          '',
          ''
        ]);
    return raw;
  }


  update(NoteModel item) async {
    final db = await database;
    var res = await db
        .update("note", item.toJson(), where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<List<NoteModel>> getById(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM note WHERE id = ?", [id]);
    List<NoteModel> list =
    res.isNotEmpty ? res.map((c) => NoteModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<NoteModel>> getAll() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM note");
    List<NoteModel> list =
    res.isNotEmpty ? res.map((c) => NoteModel.fromJson(c)).toList() : [];
    return list;
  }


  deleteById(int id) async {
    final db = await database;
    return db.delete("note", where: "id = ?", whereArgs: [id]);
  }

}
