import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo_task_model.dart';

class DatabaseHelper{
  static Database? _db;
 static Future<Database?> get database async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDatabase();
      return _db;
    }
  }
 static Future<Database?> initDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, "todo-list.db");
      return await openDatabase(path,version: 1, onCreate: _onCreate);
    } catch (e) {
      return null;

    }
  }

 static Future<void> _onCreate(Database db,int version)async{
    try {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          image BLOB,
          isCompleted INTEGER
        )
      ''');

    } catch (e) {
      print("Error creating table: $e");
    }
    return;
  }

 static Future<void> insertData(TodoTaskModel task) async {
    var db = await database;
    if (db != null) {
      try {
        await db.insert('tasks', task.toMap());

      } catch (e) {
        print("Error inserting data: $e");
        rethrow;
      }
    } else {
      print("Database is null");
      throw Exception("Database is null");
    }
    return;

  }

static  Future<void> deleteTasks(int id) async {
    var db = await database;
    if (db != null) {
      try {
        await db.delete('tasks', where: 'id = ?', whereArgs: [id]);

      } catch (e) {
        print("Error deleting tasks: $e");
        rethrow;
      }
    } else {
      print("Database is null");
      throw Exception("Database is null");
    }
  }

static  Future<void> update(TodoTaskModel user) async {
    var db = await database;
    if (db != null) {
      try {
        await db.update(
          'tasks',
          user.toMap(),
          where: 'id = ?',
          whereArgs: [user.id],
        );

      } catch (e) {
        print("Error updating tasks: $e");
        rethrow;
      }
    } else {
      print("Database is null");
      throw Exception("Database is null");
    }
  }


  static Future<List<TodoTaskModel>> fetchData() async {
    var db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('tasks');
    return maps.map((task)=> TodoTaskModel.fromMap(task)).toList();
    // return List.generate(maps.length, (i) {
    //   return TodoTaskModel(
    //     id: maps[i]['id'],
    //     title: maps[i]['title'],
    //     description: maps[i]['description'],
    //     image: maps[i]['image'],
    //     isCompleted: maps[i]['isCompleted'],
    //   );
    // });
  }


}