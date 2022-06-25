import 'package:quizz_game_app/Modal/quiz/quiz_modal.dart';
import 'package:quizz_game_app/Modal/quiz/quiz_question_modal.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstracotr();
  static final DatabaseHelper instance = DatabaseHelper._privateConstracotr();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await DatabaseConnection.setDatabase();

//User Table
  Future<List<UserModal>> getallUser() async {
    Database _db = await instance.database;
    var users = await _db.query(DbTable.userTable, orderBy: 'name');
    List<UserModal> userList =
        users.isEmpty ? [] : users.map((e) => UserModal.fromMap(e)).toList();
    return userList;
  }

  Future<UserModal?> getUser(String email) async {
    Database _db = await instance.database;
    List<Map<String, Object?>> _rawuser = await _db.rawQuery(
        "SELECT * from ${DbTable.userTable} Where email = ? ", [email]);
    List<UserModal?> user = _rawuser.isEmpty
        ? []
        : _rawuser.map((e) => UserModal.fromMap(e)).toList();
    return user[0];
  }

  Future<void> insertUser(UserModal user) async {
    Database _db = await instance.database;
    await _db.insert(
      DbTable.userTable,
      user.toMap(),
    );
  }

  Future<List<String>> getExistEmail() async {
    Database _db = await instance.database;
    List<Map<String, Object?>> emailList =
        await _db.rawQuery("Select email from ${DbTable.userTable}");
    List<String> email = emailList.map((e) => e['email'].toString()).toList();
    return email;
  }

  Future<void> dropTable(String table) async {
    Database _db = await instance.database;
    await _db.delete(table);
  }

  Future<void> changeUser(UserModal user) async {
    Database _db = await instance.database;
    await _db.update(DbTable.userTable, user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePhoto(UserModal user) async {
    Database _db = await instance.database;
    _db.update(DbTable.userTable, user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> changeEmail(UserModal user) async {
    Database _db = await instance.database;
    _db.update(DbTable.userTable, user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String> getUserRole({required String email}) async {
    Database _db = await instance.database;
    List<Map<String, Object?>> roles = await _db.rawQuery(
        "Select role FROM ${DbTable.userTable} Where email = ?", [email]);
    String _role = roles.map((e) => e['role'].toString()).toString();
    return _role;
  }
  //################################################# User End #######################################################

  //Quiz Table
  Future<void> insertQuizHead(QuizModal quizModal) async{
    Database _db = await instance.database;
    await _db.insert(DbTable.headQuizTable, quizModal.toMap());
  }

  Future<List<QuizModal>> getQuizHeader() async{
    Database _db = await instance.database;
    List<Map<String, Object?>> _quizs = await _db.rawQuery("SELECT * FROM  ${DbTable.headQuizTable}  ORDER BY id DESC ");
    List<QuizModal> _quizModal = _quizs.isEmpty ? [] : _quizs.map((e) => QuizModal.fromMap(e)).toList();
    return _quizModal;
  }

  Future<void> deleteQuizHeader(int id)async{
    Database _db = await instance.database;
    await _db.delete(DbTable.headQuizTable, where: 'id = ?',whereArgs: [id],);
  }

  Future<void> quizQuestionAdd (QuizQuestionModal modal) async{
    Database _db = await instance.database;
    await _db.insert(DbTable.quizTable, modal.toMap());
  }

  Future<List<QuizQuestionModal>> getQuizQuestion(String keyword)async{
    Database _db = await instance.database;
    List<Map<String, Object?>> _questions = await _db.rawQuery("Select * from ${DbTable.quizTable} where keyword = ? ORDER BY id DESC",[keyword]);
    List<QuizQuestionModal> _questionModal = _questions.isEmpty ? [] : _questions.map((e) => QuizQuestionModal.fromMap(e)).toList();
    return _questionModal;
  }
}
