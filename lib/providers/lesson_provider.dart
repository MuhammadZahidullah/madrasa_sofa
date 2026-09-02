import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/lesson.dart';
import 'package:madrasa_soffa/repositories/lesson_repository.dart';

class LessonProvider with ChangeNotifier {
  final LessonRepository _lessonRepository = LessonRepository();
  List<Lesson> _lessons = [];

  List<Lesson> get lessons => _lessons;

  Future<void> loadLessons() async {
    _lessons = await _lessonRepository.getAllLessons();
    notifyListeners();
  }

  Future<void> loadLessonsForStudent(int studentId) async {
    _lessons = await _lessonRepository.getLessonsForStudent(studentId);
    notifyListeners();
  }

  Future<void> addOrUpdateLesson(Lesson lesson) async {
    await _lessonRepository.addOrUpdateLesson(lesson);
    await loadLessons();
  }
}
