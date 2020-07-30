import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'ImageModel.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "image_saves.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Client ("
              "id INTEGER PRIMARY KEY,"
              "first_name TEXT,"
              "last_name TEXT,"
              "blocked BIT"
              ")");
        });
  }

  newImage(ImageModel newImage) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM ImageModel");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into ImageModel (id,description,author,smallUrl,bigUrl) "
            "VALUES (?,?,?,?,?)",
          [id,newImage.description, newImage.author, newImage.smallUrl, newImage.bigUrl]
    );
    return raw;
  }

  getImage(int id) async {
    final db = await database;
    var res = await db.query("ImageModel", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ImageModel.fromJson(res.first) : null;
  }

  getAllImages() async {
    final db = await database;
    var res = await db.query("ImageModel");
    List<ImageModel> list =
        res.isNotEmpty ? res.map((i) => ImageModel.fromJson(i)).toList(): [];
    return list;
  }
}
