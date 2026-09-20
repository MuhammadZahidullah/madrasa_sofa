import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/teacher.dart';
import '../providers/teacher_provider.dart';
import '../../../classes/domain/entities/madrasa_class.dart';
import '../../../classes/presentation/providers/madrasa_class_provider.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/presentation/providers/subject_provider.dart';
import '../../../teaching_assignments/domain/entities/teaching_assignment.dart';
import '../../../teaching_assignments/presentation/providers/teaching_assignment_provider.dart';

class _AssignmentRowData {
  String? classId;
  String? subjectId;

  _AssignmentRowData({this.classId, this.subjectId});
}

class AddEditTeacherScreen extends StatefulWidget {
  final Teacher? teacher;

  const AddEditTeacherScreen({super.key, this.teacher});

  @override
  State<AddEditTeacherScreen> createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _fatherNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _qualificationController;
  late bool _isActive;

  List<_AssignmentRowData> _assignments = [];

  bool get _isEditing => widget.teacher != null;
  bool _isLoadingAssignments = false;

  @override
  void initState() {
    super.initState();
    final t = widget.teacher;
    _nameController = TextEditingController(text: t?.name ?? '');
    _fatherNameController = TextEditingController(text: t?.fatherName ?? '');
    _phoneController = TextEditingController(text: t?.phone ?? '');
    _addressController = TextEditingController(text: t?.address ?? '');
    _qualificationController = TextEditingController(
      text: t?.qualification ?? '',
    );
    _isActive = t?.isActive ?? true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final classProvider = Provider.of<MadrasaClassProvider>(context, listen: false);
      if (classProvider.classes.isEmpty && classProvider.error == null) {
        classProvider.fetchClasses();
      }

      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
      if (subjectProvider.subjects.isEmpty && subjectProvider.error == null) {
        subjectProvider.fetchSubjects();
      }

      if (_isEditing) {
        setState(() {
          _isLoadingAssignments = true;
        });
        final assignmentProvider = Provider.of<TeachingAssignmentProvider>(context, listen: false);
        await assignmentProvider.fetchAssignmentsForTeacher(widget.teacher!.id);
        
        final loadedAssignments = assignmentProvider.getAssignmentsForTeacher(widget.teacher!.id);
        setState(() {
          _assignments = loadedAssignments.map((a) => _AssignmentRowData(classId: a.classId, subjectId: a.subjectId)).toList();
          _isLoadingAssignments = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  String _getLocalizedClassName(BuildContext context, MadrasaClass madrasaClass) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur':
        return madrasaClass.nameUr.trim().isNotEmpty ? madrasaClass.nameUr : madrasaClass.nameEn;
      case 'ar':
        return madrasaClass.nameAr.trim().isNotEmpty ? madrasaClass.nameAr : madrasaClass.nameEn;
      case 'en':
      default:
        return madrasaClass.nameEn.trim().isNotEmpty
            ? madrasaClass.nameEn
            : (madrasaClass.nameUr.trim().isNotEmpty ? madrasaClass.nameUr : madrasaClass.nameAr);
    }
  }

  String _getLocalizedSubjectName(BuildContext context, Subject subject) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur':
        return subject.nameUr.trim().isNotEmpty ? subject.nameUr : subject.nameEn;
      case 'ar':
        return subject.nameAr.trim().isNotEmpty ? subject.nameAr : subject.nameEn;
      case 'en':
      default:
        return subject.nameEn.trim().isNotEmpty
            ? subject.nameEn
            : (subject.nameUr.trim().isNotEmpty ? subject.nameUr : subject.nameAr);
    }
  }

  bool _hasDuplicateAssignments() {
    final seen = <String>{};
    for (var row in _assignments) {
      if (row.classId != null && row.subjectId != null) {
        final key = '${row.classId}_${row.subjectId}';
        if (seen.contains(key)) {
          return true;
        }
        seen.add(key);
      }
    }
    return false;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final l10n = AppLocalizations.of(context)!;
    
    // Validate assignments are fully selected
    for (var row in _assignments) {
      if (row.classId == null || row.subjectId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.fieldRequired), // Or a specific error
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    if (_hasDuplicateAssignments()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.duplicateAssignmentError),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final provider = Provider.of<TeacherProvider>(context, listen: false);
    final assignmentProvider = Provider.of<TeachingAssignmentProvider>(context, listen: false);

    final String teacherId = widget.teacher?.id ?? FirebaseFirestore.instance.collection('teachers').doc().id;

    final teacher = Teacher(
      id: teacherId,
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      qualification: _qualificationController.text.trim().isEmpty ? null : _qualificationController.text.trim(),
      // Keep assignedClassIds for backward compatibility, but don't add new ones.
      assignedClassIds: widget.teacher?.assignedClassIds ?? [],
      isActive: _isActive,
      createdAt: widget.teacher?.createdAt ?? DateTime.now(),
    );

    final bool success;
    if (_isEditing) {
      success = await provider.updateTeacher(teacher);
    } else {
      success = await provider.addTeacher(teacher);
    }

    if (!success) {
      if (!mounted) return;
      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    // Save assignments
    final newAssignments = _assignments.map((row) {
      return TeachingAssignment(
        id: '', // Will be generated by Firestore batch insert
        teacherId: teacherId,
        classId: row.classId!,
        subjectId: row.subjectId!,
        createdAt: DateTime.now(),
      );
    }).toList();

    final assignmentSuccess = await assignmentProvider.saveAssignmentsForTeacher(teacherId, newAssignments);

    if (!mounted) return;

    if (assignmentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? l10n.teacherUpdatedSuccess : l10n.teacherAddedSuccess),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      Navigator.pop(context);
    } else if (assignmentProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(assignmentProvider.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<TeacherProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.editTeacher : l10n.addNewTeacher,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(
                  context,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.teacherName,
                        hintText: l10n.enterTeacherName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.nameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fatherNameController,
                      decoration: InputDecoration(
                        labelText: l10n.fatherName,
                        hintText: l10n.enterFatherName,
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.fatherNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qualificationController,
                      decoration: InputDecoration(
                        labelText: l10n.qualification,
                        hintText: l10n.enterQualification,
                        prefixIcon: const Icon(Icons.school_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.phone,
                        hintText: l10n.enterPhone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: l10n.address,
                        hintText: l10n.enterAddress,
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.status,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        _isActive ? l10n.active : l10n.inactive,
                        style: TextStyle(
                          color: _isActive
                              ? AppTheme.primaryColor
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _isActive,
                      activeThumbColor: AppTheme.primaryColor,
                      onChanged: (val) => setState(() => _isActive = val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.assignment_outlined, color: AppTheme.secondaryAccent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          l10n.teachingAssignments,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 1, thickness: 0.8, color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                    const SizedBox(height: 12),
                    
                    if (_isLoadingAssignments)
                      const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
                    else
                      ..._buildAssignmentRows(context, l10n, isDark),
                      
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _assignments.add(_AssignmentRowData());
                        });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addAssignment),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isEditing ? l10n.updateTeacher : l10n.saveTeacher,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAssignmentRows(BuildContext context, AppLocalizations l10n, bool isDark) {
    if (_assignments.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            l10n.noAssignmentsAdded,
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        )
      ];
    }

    final classProvider = Provider.of<MadrasaClassProvider>(context);
    final subjectProvider = Provider.of<SubjectProvider>(context);
    
    final activeClasses = classProvider.classes.where((c) => c.isActive).toList();
    final activeSubjects = subjectProvider.subjects.where((s) => s.isActive).toList();

    return _assignments.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.black12 : Colors.grey[50],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.assignment} ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _assignments.removeAt(index);
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.close, size: 18, color: Colors.redAccent),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: row.classId,
              decoration: InputDecoration(
                labelText: l10n.selectClass,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: activeClasses.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text(_getLocalizedClassName(context, c)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  row.classId = val;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: row.subjectId,
              decoration: InputDecoration(
                labelText: l10n.subjects, // Better to use selectSubject if available, reusing subjects for now
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: activeSubjects.map((s) {
                return DropdownMenuItem(
                  value: s.id,
                  child: Text(_getLocalizedSubjectName(context, s)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  row.subjectId = val;
                });
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
