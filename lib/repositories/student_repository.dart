import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class StudentRepository {
  final dbService = DatabaseService();

  Future<int> addStudent(Student student) async {
    final db = await dbService.database;
    return await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> getStudents() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<int> updateStudent(Student student) async {
    final db = await dbService.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await dbService.database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
