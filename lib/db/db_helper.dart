import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      print("Using already created one");
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';

      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("Creating a new one");
        return db.execute("CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, isCompleted INTEGER )");
      });

      print("table created");
    } catch (error) {
      print(error);
    }
  }

  static Future<int> insertTask(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>?> query() async {
    print("Query function called");
    if (_db == null) {
      return null;
    } else {
      return await _db!.query(_tableName);
    }
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static update(int id) async {
    await _db!.rawUpdate(
        '''UPDATE $_tableName SET isCompleted =? WHERE id =?''', [1, id]);
  }
}
