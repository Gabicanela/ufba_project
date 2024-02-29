import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Modelo para representar os dados do IMC
class IMC {
  final int? id;
  final String nome;
  final double altura;
  final double peso;
  final double imc;

  IMC({this.id, required this.nome, required this.altura, required this.peso, required this.imc});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'altura': altura,
      'peso': peso,
      'imc': imc,
    };
  }
}

// Classe helper para interagir com o banco de dados SQLite
class DatabaseHelper {
  static Future<Database> database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'imc_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE imc(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, altura INTEGER, peso REAL, imc REAL)',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<void> insertIMC(IMC imc) async {
    final db = await database();
    await db.insert(
      'imc',
      imc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<IMC>> getAllIMCs() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query('imc');
    return List.generate(maps.length, (i) {
      return IMC(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        altura: maps[i]['altura'],
        peso: maps[i]['peso'],
        imc: maps[i]['imc'],
      );
    });
  }
}
