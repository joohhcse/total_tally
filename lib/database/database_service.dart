import 'package:path/path.dart';

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
            quantity INTEGER,
            price REAL
          )
        ''');

        List<Product> initTally = [
        ];

        Batch batch = db.batch();
        initTally.forEach((product) {
          batch.insert('tally_table', product.toMap());
        });

        await batch.commit();
      },
    );

    return initDb;
  }

  //copyWith, toMap error?? : sqflite: ^2.0.0+3 : sqflite version problem
  Future<Product> insert(Product product) async {
    // final db = await this.db;
    final Database db = await database;
    final id = await db.insert('tally_table', product.toMap());
    final quoteWithId = product.copyWith(id: id);
    return quoteWithId;
  }

  Future<List<Product>> getAllProduct() async {
    final db = await database;
    final productData = await db.query('tally_table');
    return productData.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> deleteProduct(int id) async {
    final Database db = await database;
    return await db.delete(
      'tally_table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalPriceOfAllProducts() async {
    final List<Product> products = await getAllProduct();
    double totalPrice = 0;

    // 각 제품의 가격과 수량을 곱하여 총 가격을 계산합니다.
    for (var product in products) {
      totalPrice += product.price * product.quantity;
    }

    return totalPrice;
  }
}