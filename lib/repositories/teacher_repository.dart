import 'package:madrasa_soffa/models/teacher.dart';
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class TeacherRepository {
  final dbService = DatabaseService();

  Future<int> addTeacher(Teacher teacher) async {
    final db = await dbService.database;
    return await db.insert(
      'teachers',
      teacher.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Teacher>> getTeachers() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('teachers');
    return List.generate(maps.length, (i) {
      return Teacher.fromMap(maps[i]);
    });
  }

  Future<int> updateTeacher(Teacher teacher) async {
    final db = await dbService.database;
    return await db.update(
      'teachers',
      teacher.toMap(),
      where: 'id = ?',
      whereArgs: [teacher.id],
    );
  }

  Future<int> deleteTeacher(int id) async {
    final db = await dbService.database;
    return await db.delete('teachers', where: 'id = ?', whereArgs: [id]);
  }
}
