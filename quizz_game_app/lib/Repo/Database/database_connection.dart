import 'dart:io';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  static Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'Quiz_db');
    Database database =
        await openDatabase(path, version: 6, onCreate: _createTable, onUpgrade: _onUpgrade, );
    return database;
  }

  static Future<void> _createTable(Database database, int version) async {
    await database.execute('''CREATE TABLE ${DbTable.userTable}(
                              id INTEGER PRIMARY KEY autoincrement,
                              name TEXT,
                              email TEXT,
                              photo TEXT,
                              role TEXT,
                              score INTEGER ) ''');
  }

  static Future<void> _onUpgrade(Database database, int oldversion, int newversion)async{
    if(newversion > oldversion){
      await database.execute('''CREATE TABLE ${DbTable.quizTable}(
                              id INTEGER PRIMARY KEY autoincrement,
                              keyword TEXT,
                              questoin TEXT,
                              answer1 TEXT,
                              answer2 TEXT,
                              answer3 TEXT,
                              rightAnswer INTEGER)''');
    await database.execute('''Create TABLE ${DbTable.headQuizTable}(
                              id INTEGER PRIMARY KEY autoincrement,
                              photo TEXT,
                              title TEXT,
                              description TEXT,
                              date TEXT)''');
    }
  }
}
