import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/core/localization/locale_provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/providers/attendance_provider.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/providers/fee_provider.dart';
import 'package:madrasa_soffa/providers/lesson_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/providers/teacher_provider.dart';
import 'package:madrasa_soffa/screens/home_screen.dart';
import 'package:madrasa_soffa/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          create: (_) => StudentProvider()..loadStudents(),
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
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Madrasa Soffa',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: localeProvider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
              Locale('ar'),
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
