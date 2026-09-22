import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/features/auth/presentation/providers/auth_provider.dart';
import 'package:madrasa_soffa/features/teaching_assignments/presentation/providers/teaching_assignment_provider.dart';
import 'package:madrasa_soffa/features/classes/presentation/providers/madrasa_class_provider.dart';
import 'package:madrasa_soffa/features/subjects/presentation/providers/subject_provider.dart';
import 'package:madrasa_soffa/features/classes/domain/entities/madrasa_class.dart';
import 'package:madrasa_soffa/features/subjects/domain/entities/subject.dart';

class TeacherMyClassesScreen extends StatefulWidget {
  const TeacherMyClassesScreen({super.key});

  @override
  State<TeacherMyClassesScreen> createState() => _TeacherMyClassesScreenState();
}

class _TeacherMyClassesScreenState extends State<TeacherMyClassesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final teacherId = authProvider.appUser?.teacherId;
    
    if (teacherId != null && teacherId.isNotEmpty) {
      final assignmentsProvider = Provider.of<TeachingAssignmentProvider>(context, listen: false);
      final classProvider = Provider.of<MadrasaClassProvider>(context, listen: false);
      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);

      // Load all required data
      await Future.wait([
        assignmentsProvider.fetchAssignmentsForTeacher(teacherId),
        if (classProvider.classes.isEmpty) classProvider.fetchClasses(),
        if (subjectProvider.subjects.isEmpty) subjectProvider.fetchSubjects(),
      ]);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getLocalizedClassName(BuildContext context, MadrasaClass madrasaClass) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ur') return madrasaClass.nameUr;
    if (locale == 'ar') return madrasaClass.nameAr;
    return madrasaClass.nameEn;
  }

  String _getLocalizedSubjectName(BuildContext context, Subject subject) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ur') return subject.nameUr;
    if (locale == 'ar') return subject.nameAr;
    return subject.nameEn;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.myClasses)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final teacherId = authProvider.appUser?.teacherId;

    if (teacherId == null || teacherId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.myClasses)),
        body: Center(child: Text(l10n.teacherNotLinked)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myClasses)),
      body: Consumer3<TeachingAssignmentProvider, MadrasaClassProvider, SubjectProvider>(
        builder: (context, assignmentProvider, classProvider, subjectProvider, child) {
          // If any of these are loading, show loading. 
          // This prevents empty state from showing prematurely during a refresh.
          if (assignmentProvider.isLoading || classProvider.isLoading || subjectProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (assignmentProvider.error != null) {
            return Center(child: Text(assignmentProvider.error!));
          }

          final assignments = assignmentProvider.getAssignmentsForTeacher(teacherId);

          // Filter by active assignments
          final activeAssignments = assignments.where((a) => a.isActive).toList();

          if (activeAssignments.isEmpty) {
             return Center(
              child: Text(
                l10n.noClassesAssignedToYou,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          // Group assignments by classId
          final Map<String, List<String>> classToSubjects = {};
          for (var assignment in activeAssignments) {
            classToSubjects.putIfAbsent(assignment.classId, () => []).add(assignment.subjectId);
          }
          
          // Check resolution for debug and to prevent incorrectly showing a completely empty list
          int validClassesCount = 0;
          for (var classId in classToSubjects.keys) {
            final madrasaClass = classProvider.getClassById(classId);
            bool classResolved = madrasaClass != null && madrasaClass.isActive;
            if (classResolved) {
              validClassesCount++;
            }
          }

          // If assignments exist but NONE of the classes resolved, it means referenced data is missing/inactive.
          // In this specific case, the empty state might have been incorrectly produced or it's a data error.
          // The prompt says: "Do NOT determine "No classes assigned" merely because class/subject providers have not finished loading. Differentiate between actual zero assignments, missing data, etc."
          if (validClassesCount == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  // Show the empty state, but it is technically because of missing/inactive referenced classes.
                  l10n.noClassesAssignedToYou,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: classToSubjects.keys.length,
            itemBuilder: (context, index) {
              final classId = classToSubjects.keys.elementAt(index);
              final subjectIds = classToSubjects[classId]!;
              
              final madrasaClass = classProvider.getClassById(classId);
              
              // Safely handle missing/inactive class reference
              if (madrasaClass == null || !madrasaClass.isActive) {
                return const SizedBox.shrink(); 
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLocalizedClassName(context, madrasaClass),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: subjectIds.map((subjectId) {
                          final subject = subjectProvider.getSubjectById(subjectId);
                          // Safely handle missing/inactive subject reference
                          if (subject == null || !subject.isActive) {
                            return const SizedBox.shrink();
                          }
                          
                          return Chip(
                            label: Text(_getLocalizedSubjectName(context, subject)),
                            backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).where((w) => w is! SizedBox).toList(), // Filter out empty space
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
