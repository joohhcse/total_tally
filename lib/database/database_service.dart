import 'package:path/path.dart';
// import 'package:total_tally/model/';

import 'package:total_tally/model/Product.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static const DatabaseService instance = DatabaseService._();

  const DatabaseService._();

  static Database? _db;

  // Future<Database> _openDb() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'totaltally_database.db');
  // }

  Future<Database> get database async {
    print('Future<Database> get db async >>>>>');
    _db ??= await _openDb();
    return _db!;

    // if(_db != null) {
    //   return db!;
    // }
    //
    // _db ??= await _openDb();
    // return _db!;
  }

  Future<Database> _openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quote_database.db');
    // await deleteDatabase(path);  //remove // 이 코드로 계속 재실행하면 디비 초기화됨

    final initDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tally_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          )
        ''');

        List<Product> initTally = [
          Product(id: 1, name: 'item1', price: 123),
          Product(id: 2, name: 'item2', price: 234),
          Product(id: 3, name: 'item3', price: 345),
        ]

        Batch batch = db.batch();
        initTally.forEach((product) {
          batch.insert('tally_table', product.toMap());
        });

        await batch.commit();
      },
    );

    return initDb;
  }

  Future<Product> insert(Product product) async { //copyWith, toMap error?? : sqflite: ^2.0.0+3 : sqflite version problem
    // final db = await this.db;
    final Database db = await database;
    final id = await db.insert('tally_table', product.toMap());
    final quoteWithId = product.copyWith(id: id);
    return quoteWithId;
  }


}