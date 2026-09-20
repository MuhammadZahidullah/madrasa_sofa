import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/teacher.dart';
import '../providers/teacher_provider.dart';
import '../../../classes/domain/entities/madrasa_class.dart';
import '../../../classes/presentation/providers/madrasa_class_provider.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/presentation/providers/subject_provider.dart';
import '../../../teaching_assignments/presentation/providers/teaching_assignment_provider.dart';
import 'add_edit_teacher_screen.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
      if (teacherProvider.teachers.isEmpty && teacherProvider.error == null) {
        teacherProvider.fetchTeachers();
      }

      final classProvider = Provider.of<MadrasaClassProvider>(context, listen: false);
      if (classProvider.classes.isEmpty && classProvider.error == null) {
        classProvider.fetchClasses();
      }

      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
      if (subjectProvider.subjects.isEmpty && subjectProvider.error == null) {
        subjectProvider.fetchSubjects();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<TeacherProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredTeachers = provider.teachers.where((teacher) {
      if (_searchQuery.isEmpty) return true;
      final nameMatch = teacher.name.toLowerCase().contains(_searchQuery);
      final fatherMatch = teacher.fatherName.toLowerCase().contains(_searchQuery);
      final phoneMatch = (teacher.phone ?? '').toLowerCase().contains(_searchQuery);
      final qualMatch = (teacher.qualification ?? '').toLowerCase().contains(_searchQuery);
      return nameMatch || fatherMatch || phoneMatch || qualMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.teachers,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: l10n.addTeacher,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditTeacherScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchTeachers,
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: AppTheme.secondaryAccent, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildBody(context, provider, filteredTeachers, isDark, l10n),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.secondaryAccent,
        foregroundColor: Colors.white,
        elevation: 3,
        tooltip: l10n.addTeacher,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTeacherScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TeacherProvider provider, List<Teacher> filteredTeachers, bool isDark, AppLocalizations l10n) {
    if (provider.isLoading && provider.teachers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.secondaryAccent),
      );
    }

    if (provider.error != null && provider.teachers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 54, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(l10n.errorLoadingTeachers, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.fetchTeachers(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryAccent, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.teachers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined, size: 64, color: isDark ? Colors.grey[600] : Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                l10n.noTeachersYet,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditTeacherScreen()));
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addTeacher),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredTeachers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 54, color: isDark ? Colors.grey[600] : Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                l10n.noTeachersFound,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.secondaryAccent,
      onRefresh: () => provider.fetchTeachers(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: filteredTeachers.length,
        itemBuilder: (context, index) {
          final teacher = filteredTeachers[index];
          return TeacherCard(key: ValueKey(teacher.id), teacher: teacher);
        },
      ),
    );
  }
}

class TeacherCard extends StatefulWidget {
  final Teacher teacher;
  
  const TeacherCard({super.key, required this.teacher});

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  bool _isLoadingAssignments = false;

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }
  
  @override
  void didUpdateWidget(TeacherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.teacher.id != widget.teacher.id) {
      _fetchAssignments();
    }
  }

  void _fetchAssignments() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      
      final assignmentProvider = Provider.of<TeachingAssignmentProvider>(context, listen: false);
      final existingAssignments = assignmentProvider.getAssignmentsForTeacher(widget.teacher.id);
      
      if (existingAssignments.isEmpty) {
        setState(() => _isLoadingAssignments = true);
        await assignmentProvider.fetchAssignmentsForTeacher(widget.teacher.id);
        if (mounted) {
          setState(() => _isLoadingAssignments = false);
        }
      }
    });
  }

  String _getLocalizedClassName(BuildContext context, MadrasaClass madrasaClass) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur': return madrasaClass.nameUr.trim().isNotEmpty ? madrasaClass.nameUr : madrasaClass.nameEn;
      case 'ar': return madrasaClass.nameAr.trim().isNotEmpty ? madrasaClass.nameAr : madrasaClass.nameEn;
      case 'en':
      default: return madrasaClass.nameEn.trim().isNotEmpty ? madrasaClass.nameEn : (madrasaClass.nameUr.trim().isNotEmpty ? madrasaClass.nameUr : madrasaClass.nameAr);
    }
  }

  String _getLocalizedSubjectName(BuildContext context, Subject subject) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur': return subject.nameUr.trim().isNotEmpty ? subject.nameUr : subject.nameEn;
      case 'ar': return subject.nameAr.trim().isNotEmpty ? subject.nameAr : subject.nameEn;
      case 'en':
      default: return subject.nameEn.trim().isNotEmpty ? subject.nameEn : (subject.nameUr.trim().isNotEmpty ? subject.nameUr : subject.nameAr);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Teacher teacher) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteTeacherTitle),
        content: Text(l10n.deleteTeacherConfirmation(teacher.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<TeacherProvider>(context, listen: false);
      final success = await provider.deleteTeacher(teacher.id);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.teacherDeletedSuccess), backgroundColor: AppTheme.primaryColor),
          );
        } else if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error!), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final classProvider = Provider.of<MadrasaClassProvider>(context);
    final subjectProvider = Provider.of<SubjectProvider>(context);
    final assignmentProvider = Provider.of<TeachingAssignmentProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final assignments = assignmentProvider.getAssignmentsForTeacher(widget.teacher.id);

    final initial = widget.teacher.name.isNotEmpty ? widget.teacher.name[0].toUpperCase() : 'T';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.secondaryAccent.withValues(alpha: 0.15),
                  child: Text(initial, style: const TextStyle(color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.teacher.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.fatherName}: ${widget.teacher.fatherName}',
                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: Colors.blueAccent,
                  tooltip: l10n.edit,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEditTeacherScreen(teacher: widget.teacher)),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.redAccent,
                  tooltip: l10n.delete,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  onPressed: () => _confirmDelete(context, widget.teacher),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(height: 1, thickness: 0.8, color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (widget.teacher.qualification != null && widget.teacher.qualification!.trim().isNotEmpty)
                  _buildBadge(Icons.school_outlined, widget.teacher.qualification!, isDark),
                if (widget.teacher.phone != null && widget.teacher.phone!.trim().isNotEmpty)
                  _buildBadge(Icons.phone_outlined, widget.teacher.phone!, isDark),
                _buildStatusPill(widget.teacher.isActive, l10n),
                
                if (_isLoadingAssignments)
                   const Padding(
                     padding: EdgeInsets.symmetric(horizontal: 4.0),
                     child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                   )
                else if (assignments.isNotEmpty)
                  ...assignments.map((assignment) {
                    final cls = classProvider.getClassById(assignment.classId);
                    final subj = subjectProvider.getSubjectById(assignment.subjectId);
                    
                    final cName = cls != null ? _getLocalizedClassName(context, cls) : assignment.classId;
                    final sName = subj != null ? _getLocalizedSubjectName(context, subj) : assignment.subjectId;
                    
                    return _buildBadge(Icons.assignment_outlined, '$cName - $sName', isDark);
                  })
                else
                  _buildBadge(Icons.assignment_outlined, l10n.noAssignmentsAdded, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[300] : Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool isActive, AppLocalizations l10n) {
    final color = isActive ? AppTheme.primaryColor : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(
            isActive ? l10n.active : l10n.inactive,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
