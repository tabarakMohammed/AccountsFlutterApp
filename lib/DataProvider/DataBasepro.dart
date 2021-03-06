import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:accounts/infoModel/Model.dart';
import 'dart:async';
import 'package:accounts/library/filePath.dart';

class SqlLight{

  final String  namesTable = "namesTable";
  final String id = "id";
  final String webNames = "webName";
  final String  emails = "Email";
  final String  passwordApps = "passward";

  static  Database database ;

  Future<Database> get db async {
    if (database == null) {
      database = await _createBase();
      return database;
    }
    else {
      return database;
    }
  }

  _createBase() async {

    String databasePath = await getDatabasesPath();
    String path = join(databasePath , 'Acounts.db');
    var db = await openDatabase(path , version: 3 , onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {

    await db.execute('CREATE TABLE $namesTable ($id INTEGER PRIMARY KEY,'
        ' $webNames TEXT, $emails TEXT, $passwordApps TEXT);'
    );

  }

  ///ENTER_VALUE_TO_DATA_METHOD

  Future<int> saveNT(Model todo) async {
    var dbClient = await db;
    var result = await dbClient.insert(namesTable, todo.toMap());
    return result;
  }

  ///READ_METHOD
  Future<List> retrieveN() async{
    var dbClient = await db;

    var result = await dbClient.query(
        namesTable,
        columns:
        [id,
        webNames,
        emails,
        passwordApps]
    );
    return result.toList();
  }

  ///DELETE_METHOD

  Future<int> delete(int idi) async {
    var dbClient = await db;
    return  await dbClient.delete(
        namesTable, where: "$id = ?" , whereArgs: [idi]
    );
  }


  ///UPDATE_METHOD

  Future<int> upDate(Model todo, int idr) async {

    var dbClient = await db;
    int updated = await dbClient.update(namesTable,  todo.toMap(),
        where: '$id = ?', whereArgs: [idr]);
    return updated;

  }

  Future<File> backup( String fileName) async{

    var path = await db;
    var exists = await databaseExists(path.path);
    var myDataPath =  path.path;

    try {
      if (!exists) {
        print("data not exist");
        return null;
      } else {
        // Copy
        var data = await File(myDataPath).readAsBytes();
        //print(await File(mydatapath).readAsBytes());
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        FilePath getPath = new FilePath();
        final pathd = await getPath.appFile();
        return await File('$pathd/$fileName'+'.db').writeAsBytes(bytes);

      }
    } catch(e){
      print(e);
      return null;
    }

  }
  Future<List> readExsSqlBase(var path) async{
    Database db1 = await openDatabase('$path');
      var result = await db1.query(
          namesTable,
          columns:
          [id,
            webNames,
            emails,
            passwordApps]
      );
      print(result.toList());
      await db1.close();
      return result.toList();

  }

  Future<List> searchByName(String webName) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM "
        "$namesTable WHERE $webNames "
        "LIKE '%$webName%'");

    return result.toList();
  }

  Future drop() async {
    var path = await db;
  return  await deleteDatabase(path.path);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}