import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/student.dart';
import '../providers/student_provider.dart';
import '../../../classes/domain/entities/madrasa_class.dart';
import '../../../classes/presentation/providers/madrasa_class_provider.dart';
import 'add_edit_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  final String? classId;
  final String? className;

  const StudentsScreen({super.key, this.classId, this.className});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
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
      final provider = Provider.of<StudentProvider>(context, listen: false);
      if (provider.students.isEmpty && provider.error == null) {
        provider.fetchStudents();
      }
      final classProvider = Provider.of<MadrasaClassProvider>(
        context,
        listen: false,
      );
      if (classProvider.classes.isEmpty && classProvider.error == null) {
        classProvider.fetchClasses();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, Student student) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteStudentTitle),
        content: Text(l10n.deleteStudentConfirmation(student.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      final success = await provider.deleteStudent(student.id);

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.studentDeletedSuccess),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      } else if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  String _getLocalizedClassName(
    BuildContext context,
    MadrasaClass madrasaClass,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur':
        return madrasaClass.nameUr.trim().isNotEmpty
            ? madrasaClass.nameUr
            : madrasaClass.nameEn;
      case 'ar':
        return madrasaClass.nameAr.trim().isNotEmpty
            ? madrasaClass.nameAr
            : madrasaClass.nameEn;
      case 'en':
      default:
        return madrasaClass.nameEn.trim().isNotEmpty
            ? madrasaClass.nameEn
            : (madrasaClass.nameUr.trim().isNotEmpty
                ? madrasaClass.nameUr
                : madrasaClass.nameAr);
    }
  }

  String _getTitle(
    BuildContext context,
    MadrasaClassProvider classProvider,
    AppLocalizations l10n,
  ) {
    if (widget.classId == null) {
      return l10n.students;
    }
    if (widget.classId == 'unassigned') {
      return l10n.unassignedStudents;
    }
    final currentClass = classProvider.getClassById(widget.classId!);
    if (currentClass != null) {
      return _getLocalizedClassName(context, currentClass);
    }
    return widget.className ?? l10n.students;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<StudentProvider>(context);
    final classProvider = Provider.of<MadrasaClassProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredStudents = provider.students.where((student) {
      if (widget.classId != null) {
        if (widget.classId == 'unassigned') {
          // Unassigned filter
          if (student.classId.isNotEmpty &&
              classProvider.getClassById(student.classId) != null) {
            return false;
          }
        } else if (student.classId != widget.classId) {
          return false;
        }
      }

      if (_searchQuery.isEmpty) return true;
      final nameMatch = student.name.toLowerCase().contains(_searchQuery);
      final fatherMatch = student.fatherName.toLowerCase().contains(
        _searchQuery,
      );
      final rollMatch = student.rollNumber.toLowerCase().contains(_searchQuery);
      return nameMatch || fatherMatch || rollMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(context, classProvider, l10n),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: l10n.addStudent,
            onPressed: () {
              debugPrint('StudentsScreen received classId: ${widget.classId}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditStudentScreen(
                    predefinedClassId: widget.classId == 'unassigned'
                        ? null
                        : widget.classId,
                  ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchStudents,
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.08),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.08),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildBody(
                context,
                provider,
                classProvider,
                filteredStudents,
                isDark,
                l10n,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
        tooltip: l10n.addStudent,
        onPressed: () {
          debugPrint('StudentsScreen received classId: ${widget.classId}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditStudentScreen(
                predefinedClassId: widget.classId == 'unassigned'
                    ? null
                    : widget.classId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    StudentProvider provider,
    MadrasaClassProvider classProvider,
    List<Student> filteredStudents,
    bool isDark,
    AppLocalizations l10n,
  ) {
    if (provider.isLoading && provider.students.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (provider.error != null && provider.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 54,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingStudents,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.fetchStudents(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noStudentsYet,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint(
                    'StudentsScreen received classId: ${widget.classId}',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditStudentScreen(
                        predefinedClassId: widget.classId == 'unassigned'
                            ? null
                            : widget.classId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addStudent),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredStudents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 54,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noStudentsFound,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () => provider.fetchStudents(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return _buildStudentCard(
            context,
            student,
            classProvider,
            isDark,
            l10n,
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(
    BuildContext context,
    Student student,
    MadrasaClassProvider classProvider,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final initial = student.name.isNotEmpty
        ? student.name[0].toUpperCase()
        : 'S';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
          width: 1,
        ),
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
                  backgroundColor: AppTheme.primaryColor.withValues(
                    alpha: 0.15,
                  ),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.fatherName}: ${student.fatherName}',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
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
                    MaterialPageRoute(
                      builder: (_) => AddEditStudentScreen(student: student),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.redAccent,
                  tooltip: l10n.delete,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  onPressed: () => _confirmDelete(context, student),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              thickness: 0.8,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildBadge(
                  context,
                  Icons.badge_outlined,
                  '${l10n.rollNumberPrefix}${student.rollNumber}',
                  isDark,
                ),
                if (student.classId.isNotEmpty) () {
                  final cls = classProvider.getClassById(student.classId);
                  final className = cls != null
                      ? _getLocalizedClassName(context, cls)
                      : student.classId;
                  return _buildBadge(
                    context,
                    Icons.class_outlined,
                    className,
                    isDark,
                  );
                }(),
                if (student.phone != null && student.phone!.isNotEmpty)
                  _buildBadge(
                    context,
                    Icons.phone_outlined,
                    student.phone!,
                    isDark,
                  ),
                _buildStatusPill(student.isActive, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    IconData icon,
    String label,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool isActive, AppLocalizations l10n) {
    final color = isActive ? AppTheme.primaryColor : Colors.amber.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? l10n.active : l10n.inactive,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
