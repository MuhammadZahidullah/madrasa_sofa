import 'package:madrasa_soffa/models/lesson.dart';
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class LessonRepository {
  final dbService = DatabaseService();

  Future<int> addOrUpdateLesson(Lesson lesson) async {
    final db = await dbService.database;
    // Check if a lesson for this student and subject already exists
    final existing = await db.query(
      'lessons',
      where: 'studentId = ? AND subject = ?',
      whereArgs: [lesson.studentId, lesson.subject],
    );

    if (existing.isNotEmpty) {
      // Update
      return await db.update(
        'lessons',
        lesson.toMap(),
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Insert
      return await db.insert(
        'lessons',
        lesson.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Lesson>> getLessonsForStudent(int studentId) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'lessons',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) {
      return Lesson.fromMap(maps[i]);
    });
  }

  Future<List<Lesson>> getAllLessons() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('lessons');
    return List.generate(maps.length, (i) {
      return Lesson.fromMap(maps[i]);
    });
  }
}
