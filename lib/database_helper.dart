import 'package:calculator_app/calculation_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  //singleton instance of the class
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._();

  static Database? _database;
  //getter for database initialization
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }
  //this function create the database if it does not exist or initialize it otherwise
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {

        return db.execute(
          'CREATE TABLE IF NOT EXISTS calculations(id INTEGER primary key, expression TEXT, result real, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP)',
        );
      },
    );
  }


  //this function is used to insert a new calculation in calculations table
  Future<void> insertCalculation(Calculation calculation) async {

    final db = await database;


    await db.insert(
      'calculations',
      calculation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  /*Future<void> updateCalculation(Calculation calculation) async {

    final db = await database;

    await db.update(
      'calculations',
      calculation.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }*/


  //this function is used to delete a calculation from calculations table
  Future<void> deleteCalculations(List<int> ids) async {
    final db = await database;

    
    await db.delete(
      'calculations',
      where: 'id in (${ids.join(',')})',
    );
  }


  //this function is used to get calculation from calculations table using id
  Future<Calculation> getCalculation(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Calculation.fromMap(maps[0]);
  }


  //this function is used to get all claculations in the table
  Future<List<Calculation>> getCalculationsList() async {

    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('calculations');

    return List.generate(maps.length, (i) {
      return Calculation.fromMap(maps[i]);
    });
  }
}