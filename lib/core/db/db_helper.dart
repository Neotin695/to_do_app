import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';

class DBHelper {
  static Database? _db;
  static int _version = 1;
  static String _tableName = 'todo';

  static Future<void> init() async {
    if (_db != null) {
      debugPrint('db is already init');
      return;
    }
    try {
      debugPrint('db is created now');
      String path = await getDatabasesPath() + 'task.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title STRING, note TEXT,'
            'startDate STRING, endDate STRING,'
            'remind INTEGER, repeat STRING CHECK(repeat IN ("None","Daily","Weekly","Monthly")),'
            'color INTEGER,'
            'isCompleted INTEGER)',
          );
        },
      );
    } catch (e) {
      log('error db: $e');
    }
  }

  // insert to database
  Future<int?> insert(Task task) async {
    try {
      return await _db?.insert(_tableName, task.toJson());
    } catch (e) {
      return -1;
    }
  }

  // delete from table by id
  Future<int> delete(Task task) async {
    return await _db!
        .delete(_tableName, where: 'id = ?', whereArgs: [task.getId]);
  }

  Future<int> deleteAll() async {
    return await _db!.delete(_tableName);
  }

  // read data from database
  Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  // update state of task
  Future<int> updateState(int isCompleted, id) async {
    return await _db!.rawUpdate('''
      update $_tableName 
      SET isCompleted = ? 
      WHERE id = ?
    ''', [isCompleted, id]);
  }

  // update data by task modal and id
  Future<int> update(Task task, id) async {
    return await _db!
        .update(_tableName, task.toJson(), where: 'id = ? ', whereArgs: [id]);
  }
}
