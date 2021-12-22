import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:player/database/modeldata.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class HelperDatabase {
  static final HelperDatabase instance = HelperDatabase._init();

  static Database? _database;
  HelperDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    db.execute('''
             CREATE TABLE $tableName (
               ${DataModelFields.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
               ${DataModelFields.title}  TEXT,
               ${DataModelFields.url}  TEXT,
               ${DataModelFields.user}  TEXT,
               ${DataModelFields.time} TEXT )
               ''');
  }

  Future<DataModel> create(DataModel data) async {
    final db = await instance.database;
    final id = await db.insert(tableName, data.toJson());
    return data.copy(id: id);
  }

  Future<DataModel> readData(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      columns: DataModelFields.values,
      where: '${DataModelFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DataModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not founf');
    }
  }

  Future<List<DataModel>> readAllData() async {
    final db = await instance.database;

    final result = await db.query(tableName);

    return result.map((json) => DataModel.fromJson(json)).toList();
  }

  Future<int> update(DataModel data) async {
    final db = await instance.database;
    return db.update(
      tableName,
      data.toJson(),
      where: '${DataModelFields.id} = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> delete(DataModel data) async {
    final db = await instance.database;
    return db.delete(
      tableName,
      where: '${DataModelFields.id} = ?',
      whereArgs: [data.id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
