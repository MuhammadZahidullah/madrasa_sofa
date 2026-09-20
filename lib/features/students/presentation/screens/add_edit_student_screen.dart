import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/student.dart';
import '../providers/student_provider.dart';
import '../../../classes/domain/entities/madrasa_class.dart';
import '../../../classes/presentation/providers/madrasa_class_provider.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;
  final String? predefinedClassId;

  const AddEditStudentScreen({super.key, this.student, this.predefinedClassId});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _fatherNameController;
  late final TextEditingController _rollNumberController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  String? _selectedClassId;
  late bool _isActive;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameController = TextEditingController(text: s?.name ?? '');
    _fatherNameController = TextEditingController(text: s?.fatherName ?? '');
    _rollNumberController = TextEditingController(text: s?.rollNumber ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _addressController = TextEditingController(text: s?.address ?? '');
    _isActive = s?.isActive ?? true;

    if (s != null && s.classId.isNotEmpty) {
      _selectedClassId = s.classId;
    } else {
      _selectedClassId = widget.predefinedClassId;
    }

    debugPrint(
      'AddEditStudentScreen predefinedClassId: ${widget.predefinedClassId}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    _nameController.dispose();
    _fatherNameController.dispose();
    _rollNumberController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _getLocalizedClassName(BuildContext context, MadrasaClass madrasaClass) {
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final classProvider = Provider.of<MadrasaClassProvider>(
      context,
      listen: false,
    );
    final availableClasses = classProvider.classes.where((c) {
      return c.isActive || (_isEditing && c.id == widget.student?.classId);
    }).toList();

    if (availableClasses.isEmpty ||
        _selectedClassId == null ||
        _selectedClassId!.trim().isEmpty) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<StudentProvider>(context, listen: false);

    final student = Student(
      id: widget.student?.id ?? '',
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      rollNumber: _rollNumberController.text.trim(),
      classId: _selectedClassId!,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      isActive: _isActive,
      createdAt: widget.student?.createdAt ?? DateTime.now(),
    );

    final bool success;
    if (_isEditing) {
      success = await provider.updateStudent(student);
    } else {
      success = await provider.addStudent(student);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? l10n.studentUpdatedSuccess : l10n.studentAddedSuccess,
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      Navigator.pop(context);
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<StudentProvider>(context);
    final classProvider = Provider.of<MadrasaClassProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final availableClasses = classProvider.classes.where((c) {
      return c.isActive || (_isEditing && c.id == widget.student?.classId);
    }).toList();
    final hasAvailableClasses = availableClasses.isNotEmpty;
    final isSubmittable = !provider.isLoading && hasAvailableClasses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.editStudent : l10n.addNewStudent,
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
                        labelText: l10n.studentName,
                        hintText: l10n.enterStudentName,
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
                      controller: _rollNumberController,
                      decoration: InputDecoration(
                        labelText: l10n.rollNumber,
                        hintText: l10n.enterRollNumber,
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.rollNumberRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Consumer<MadrasaClassProvider>(
                      builder: (context, classProv, _) {
                        if (classProv.isLoading && classProv.classes.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  l10n.loading,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (classProv.error != null &&
                            classProv.classes.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: l10n.selectClass,
                                  prefixIcon: const Icon(
                                    Icons.class_outlined,
                                    color: Colors.redAccent,
                                  ),
                                  errorText: classProv.error,
                                ),
                                enabled: false,
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () => classProv.fetchClasses(),
                                icon: const Icon(Icons.refresh),
                                label: Text(l10n.retry),
                              ),
                            ],
                          );
                        }

                        final currentAvailable = classProv.classes.where((c) {
                          return c.isActive ||
                              (_isEditing && c.id == widget.student?.classId);
                        }).toList();

                        if (currentAvailable.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.amber.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.noClassesAvailableCreateFirst,
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final validClassId = currentAvailable.any(
                          (c) => c.id == _selectedClassId,
                        )
                            ? _selectedClassId
                            : null;

                        return DropdownButtonFormField<String>(
                          key: ValueKey(validClassId),
                          initialValue: validClassId,
                          decoration: InputDecoration(
                            labelText: l10n.selectClass,
                            prefixIcon: const Icon(Icons.class_outlined),
                          ),
                          items: currentAvailable.map((c) {
                            final localizedName = _getLocalizedClassName(
                              context,
                              c,
                            );
                            return DropdownMenuItem<String>(
                              value: c.id,
                              child: Text(localizedName),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedClassId = val;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.classRequired;
                            }
                            return null;
                          },
                        );
                      },
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmittable ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
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
                          _isEditing ? l10n.updateStudent : l10n.saveStudent,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
