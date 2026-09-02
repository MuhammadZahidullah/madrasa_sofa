import 'package:madrasa_soffa/models/fee.dart';
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class FeeRepository {
  final dbService = DatabaseService();

  Future<int> addFee(Fee fee) async {
    final db = await dbService.database;
    return await db.insert(
      'fees',
      fee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Fee>> getFeesForStudent(int studentId) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fees',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) {
      return Fee.fromMap(maps[i]);
    });
  }

  Future<List<Fee>> getAllFees() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('fees');
    return List.generate(maps.length, (i) {
      return Fee.fromMap(maps[i]);
    });
  }
}
