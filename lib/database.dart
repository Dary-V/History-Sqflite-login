import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name users.db in my directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "users.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, age TEXT, password TEXT)");
    print("Created tables");
  }

  // Retrieving users from User Tables
  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> users = new List();
    for (int i = 0; i < list.length; i++) {
      users.add(new User(list[i]["id"], list[i]["name"], list[i]["age"], list[i]["password"]));
    }
    print(users.length);
    return users;
  }


}

class User{
  int id;

  String name;
  String age;
  String password;

  User(this.id, this.name, this.age, this.password);

}