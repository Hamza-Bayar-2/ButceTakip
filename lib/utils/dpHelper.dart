import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../modals/Spendinfo.dart';

class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE spendinfo(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        gelir TEXT,
        gider TEXT,
        day TEXT,
        month TEXT,
        year TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'bka_db.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(spendinfo info) async {
    final db = await SQLHelper.db();

    final data = info.toMap();
    final id = await db.insert('spendinfo', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<spendinfo>> getItems() async {
    final db = await SQLHelper.db();
    var result = await db.query('spendinfo', orderBy: "id");
    return  List.generate(result.length, (index){
      return spendinfo.fromObject(result[index]);
    });
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it


  static Future<int> updateItem(spendinfo info) async {
    final db = await SQLHelper.db();
    final result =
    await db.update("spendinfo", info.toMap(),where: "id= ?", whereArgs: [info.id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("spendinfo", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}