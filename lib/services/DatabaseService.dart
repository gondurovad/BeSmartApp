import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Класс отвечающий за инициализацию базы данных, создание таблиц и категорий

class DatabaseService {

  static Database _database;

  static init() async {
    if (_database != null) return _database;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "besmart.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE user (id INTEGER PRIMARY KEY UNIQUE, name TEXT, email TEXT, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE category (id INTEGER PRIMARY KEY UNIQUE, name TEXT, user_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE project (id INTEGER PRIMARY KEY UNIQUE, name TEXT, description TEXT, completed_at TEXT, deadline_at TEXT, user_id INTEGER, category_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE task (id INTEGER PRIMARY KEY UNIQUE, name TEXT, deadline_date TEXT, deadline_time TEXT, description TEXT, completed_at TEXT, is_primary BIT, user_id INTEGER, project_id INTEGER, category_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE habit (id INTEGER PRIMARY KEY UNIQUE, name TEXT, lifetime TEXT,frequency integer, dawn TEXT, sunset TEXT, user_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE bad_habit (id INTEGER PRIMARY KEY UNIQUE, name TEXT, start_at TEXT, completed_at TEXT, user_id INTEGER, project_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE incident (id INTEGER PRIMARY KEY UNIQUE, incident_date TEXT, bad_habit_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.execute('CREATE TABLE note (id INTEGER PRIMARY KEY UNIQUE, name TEXT, description TEXT, user_id INTEGER, created_at TEXT, updated_at TEXT, deleted_at TEXT)');
      await db.rawInsert("INSERT Into category (id,name,user_id,created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)", [1, 'Дом', 1, new DateTime.now().toIso8601String(), '', '']);
      await db.rawInsert("INSERT Into category (id,name,user_id,created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)", [2, 'Учеба', 1, new DateTime.now().toIso8601String(), '', '']);
      await db.rawInsert("INSERT Into category (id,name,user_id,created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)", [3, 'Работа', 1, new DateTime.now().toIso8601String(), '', '']);
      await db.rawInsert("INSERT Into category (id,name,user_id,created_at,updated_at,deleted_at) VALUES (?,?,?,?,?,?)", [4, 'Свободные 10 минут', 1, new DateTime.now().toIso8601String(), '', '']);
    });
  }
}
