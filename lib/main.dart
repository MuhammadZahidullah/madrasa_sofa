import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/core/localization/locale_provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/providers/attendance_provider.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/providers/fee_provider.dart';
import 'package:madrasa_soffa/providers/lesson_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart' as legacy;
import 'package:madrasa_soffa/providers/teacher_provider.dart' as legacy_teacher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madrasa_soffa/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:madrasa_soffa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/login_user.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/logout_user.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/get_current_user.dart';
import 'package:madrasa_soffa/features/auth/presentation/providers/auth_provider.dart';
import 'package:madrasa_soffa/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:madrasa_soffa/features/students/data/datasources/student_remote_data_source.dart';
import 'package:madrasa_soffa/features/students/data/repositories/student_repository_impl.dart';
import 'package:madrasa_soffa/features/students/domain/usecases/get_students.dart';
import 'package:madrasa_soffa/features/students/domain/usecases/add_student.dart';
import 'package:madrasa_soffa/features/students/domain/usecases/update_student.dart';
import 'package:madrasa_soffa/features/students/domain/usecases/delete_student.dart';
import 'package:madrasa_soffa/features/students/presentation/providers/student_provider.dart';
import 'package:madrasa_soffa/features/classes/data/datasources/class_remote_data_source.dart';
import 'package:madrasa_soffa/features/classes/data/repositories/class_repository_impl.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/get_classes.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/seed_classes.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/add_class.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/update_class.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/delete_class.dart';
import 'package:madrasa_soffa/features/classes/domain/usecases/check_class_has_students.dart';
import 'package:madrasa_soffa/features/classes/presentation/providers/madrasa_class_provider.dart';
import 'package:madrasa_soffa/features/teachers/data/datasources/teacher_remote_data_source.dart';
import 'package:madrasa_soffa/features/teachers/data/repositories/teacher_repository_impl.dart';
import 'package:madrasa_soffa/features/teachers/domain/usecases/get_teachers.dart';
import 'package:madrasa_soffa/features/teachers/domain/usecases/add_teacher.dart';
import 'package:madrasa_soffa/features/teachers/domain/usecases/update_teacher.dart';
import 'package:madrasa_soffa/features/teachers/domain/usecases/delete_teacher.dart';
import 'package:madrasa_soffa/features/teachers/presentation/providers/teacher_provider.dart';
import 'package:madrasa_soffa/features/subjects/data/datasources/subject_remote_data_source.dart';
import 'package:madrasa_soffa/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:madrasa_soffa/features/subjects/domain/usecases/get_subjects.dart';
import 'package:madrasa_soffa/features/subjects/domain/usecases/add_subject.dart';
import 'package:madrasa_soffa/features/subjects/domain/usecases/update_subject.dart';
import 'package:madrasa_soffa/features/subjects/domain/usecases/delete_subject.dart';
import 'package:madrasa_soffa/features/subjects/presentation/providers/subject_provider.dart';
import 'package:madrasa_soffa/features/teaching_assignments/data/datasources/teaching_assignment_remote_data_source.dart';
import 'package:madrasa_soffa/features/teaching_assignments/data/repositories/teaching_assignment_repository_impl.dart';
import 'package:madrasa_soffa/features/teaching_assignments/domain/usecases/get_assignments_by_teacher.dart';
import 'package:madrasa_soffa/features/teaching_assignments/domain/usecases/save_teacher_assignments.dart';
import 'package:madrasa_soffa/features/teaching_assignments/presentation/providers/teaching_assignment_provider.dart';
import 'package:madrasa_soffa/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => legacy.StudentProvider()..loadStudents(),
        ),
        ChangeNotifierProvider(create: (_) => ClassProvider()..loadClasses()),
        ChangeNotifierProvider(
          create: (_) => legacy_teacher.TeacherProvider()..loadTeachers(),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider()..loadAttendance(),
        ),
        ChangeNotifierProvider(create: (_) => FeeProvider()..loadFees()),
        ChangeNotifierProvider(create: (_) => LessonProvider()..loadLessons()),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = AuthRemoteDataSource();
            final authRepository = AuthRepositoryImpl(remoteDataSource);
            final loginUser = LoginUser(authRepository);
            final logoutUser = LogoutUser(authRepository);
            final getCurrentUser = GetCurrentUser(authRepository);
            return AuthProvider(
              loginUser: loginUser,
              logoutUser: logoutUser,
              getCurrentUser: getCurrentUser,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = StudentRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final studentRepository = StudentRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return StudentProvider(
              getStudents: GetStudents(studentRepository),
              addStudent: AddStudent(studentRepository),
              updateStudent: UpdateStudent(studentRepository),
              deleteStudent: DeleteStudent(studentRepository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = ClassRemoteDataSourceImpl(
              FirebaseFirestore.instance,
            );
            final repository = ClassRepositoryImpl(remoteDataSource);
            return MadrasaClassProvider(
              getClassesUseCase: GetClasses(repository),
              seedClassesUseCase: SeedClasses(repository),
              addClassUseCase: AddClass(repository),
              updateClassUseCase: UpdateClass(repository),
              deleteClassUseCase: DeleteClass(repository),
              checkClassHasStudentsUseCase: CheckClassHasStudents(repository),
            )..fetchClasses();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = TeacherRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final teacherRepository = TeacherRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            
            final assignmentRemoteDataSource = TeachingAssignmentRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final assignmentRepository = TeachingAssignmentRepositoryImpl(
              remoteDataSource: assignmentRemoteDataSource,
            );
            
            return TeacherProvider(
              getTeachers: GetTeachers(teacherRepository),
              addTeacher: AddTeacher(teacherRepository),
              updateTeacher: UpdateTeacher(teacherRepository),
              deleteTeacher: DeleteTeacher(teacherRepository, assignmentRepository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = SubjectRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final subjectRepository = SubjectRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return SubjectProvider(
              getSubjects: GetSubjects(subjectRepository),
              addSubject: AddSubject(subjectRepository),
              updateSubject: UpdateSubject(subjectRepository),
              deleteSubject: DeleteSubject(subjectRepository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = TeachingAssignmentRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final repository = TeachingAssignmentRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return TeachingAssignmentProvider(
              getAssignmentsByTeacher: GetAssignmentsByTeacher(repository),
              saveTeacherAssignments: SaveTeacherAssignments(repository),
            );
          },
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Madrasa Soffa',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ur'), Locale('ar')],
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
