import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig {
  static final DatabaseConfig _instance = DatabaseConfig._internal();
  factory DatabaseConfig() => _instance;
  DatabaseConfig._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Favoritos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY, 
            topico TEXT NOT NULL,
            nome TEXT,
            categoria TEXT,
            definicao TEXT,
            comando_exemplo TEXT,
            explicacao_pratica TEXT,
            dicas_de_uso TEXT
          )
        ''');

      },
    );
  }
}
