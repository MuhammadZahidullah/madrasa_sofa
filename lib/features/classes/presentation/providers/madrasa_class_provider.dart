import 'package:flutter/foundation.dart';
import '../../domain/entities/madrasa_class.dart';
import '../../domain/usecases/add_class.dart';
import '../../domain/usecases/delete_class.dart';
import '../../domain/usecases/get_classes.dart';
import '../../domain/usecases/seed_classes.dart';
import '../../domain/usecases/update_class.dart';
import '../../domain/usecases/check_class_has_students.dart';

class MadrasaClassProvider with ChangeNotifier {
  final GetClasses getClassesUseCase;
  final SeedClasses seedClassesUseCase;
  final AddClass addClassUseCase;
  final UpdateClass updateClassUseCase;
  final DeleteClass deleteClassUseCase;
  final CheckClassHasStudents checkClassHasStudentsUseCase;

  List<MadrasaClass> _classes = [];
  bool _isLoading = false;
  String? _error;

  MadrasaClassProvider({
    required this.getClassesUseCase,
    required this.seedClassesUseCase,
    required this.addClassUseCase,
    required this.updateClassUseCase,
    required this.deleteClassUseCase,
    required this.checkClassHasStudentsUseCase,
  });

  List<MadrasaClass> get classes => _classes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First try to seed if not already seeded
      await seedClassesUseCase();

      final fetchedClasses = await getClassesUseCase();
      _classes = List<MadrasaClass>.from(fetchedClasses);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addClass(MadrasaClass madrasaClass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await addClassUseCase(madrasaClass);
      final fetchedClasses = await getClassesUseCase();
      _classes = List<MadrasaClass>.from(fetchedClasses);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateClass(MadrasaClass madrasaClass) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await updateClassUseCase(madrasaClass);
      final fetchedClasses = await getClassesUseCase();
      _classes = List<MadrasaClass>.from(fetchedClasses);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteClass(String classId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await deleteClassUseCase(classId);
      final fetchedClasses = await getClassesUseCase();
      _classes = List<MadrasaClass>.from(fetchedClasses);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MadrasaClass? getClassById(String id) {
    try {
      return _classes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> checkClassHasStudents(String classId) async {
    return await checkClassHasStudentsUseCase(classId);
  }
}

