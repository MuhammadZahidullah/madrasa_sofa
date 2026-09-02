import 'package:madrasa_soffa/models/attendance.dart';
import 'package:madrasa_soffa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceRepository {
  final dbService = DatabaseService();

  Future<int> addAttendance(Attendance attendance) async {
    final db = await dbService.database;
    return await db.insert(
      'attendance',
      attendance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Attendance>> getAttendanceByClass(
    int classId,
    String date,
  ) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'classId = ? AND date = ?',
      whereArgs: [classId, date],
    );
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getAllAttendance() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('attendance');
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }
}
