import 'package:madrasa_soffa/models/class.dart' as models;
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class ClassRepository {
  final dbService = DatabaseService();

  Future<int> addClass(models.Class classModel) async {
    final db = await dbService.database;
    return await db.insert(
      'classes',
      classModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<models.Class>> getClasses() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('classes');
    return List.generate(maps.length, (i) {
      return models.Class.fromMap(maps[i]);
    });
  }

  Future<int> updateClass(models.Class classModel) async {
    final db = await dbService.database;
    return await db.update(
      'classes',
      classModel.toMap(),
      where: 'id = ?',
      whereArgs: [classModel.id],
    );
  }

  Future<int> deleteClass(int id) async {
    final db = await dbService.database;
    return await db.delete('classes', where: 'id = ?', whereArgs: [id]);
  }
}
