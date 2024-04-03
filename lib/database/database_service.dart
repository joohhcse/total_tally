import 'package:path/path.dart';
// import 'package:total_tally/model/';

import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static const DatabaseService instance = DatabaseService._();

  const DatabaseService._();

  static Database? _db;

  // Future<Database> _openDb() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'totaltally_database.db');
  // }

}