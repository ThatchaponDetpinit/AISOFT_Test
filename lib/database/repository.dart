import 'package:sqflite/sqflite.dart';
import 'package:testsql/database/database_connection.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;

  //check database is exit or not
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection?.setDatabase();
    return _database;
  }

  //insert data
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //Read data from table
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //Read data from Id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //Update data from table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //delete data from data
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }
}
