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
import 'package:madrasa_soffa/providers/teacher_provider.dart';
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
          create: (_) => TeacherProvider()..loadTeachers(),
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
