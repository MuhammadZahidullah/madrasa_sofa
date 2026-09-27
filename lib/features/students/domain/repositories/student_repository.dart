import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  Future<List<Student>> getStudentsByClassId(String classId);
  Future<Student> getStudentById(String id);
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}
