import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/core/localization/locale_provider.dart';
import 'package:madrasa_soffa/features/students/presentation/screens/students_screen.dart';
import 'package:madrasa_soffa/features/students/presentation/providers/student_provider.dart';
import '../providers/madrasa_class_provider.dart';
import '../../domain/entities/madrasa_class.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classProvider = Provider.of<MadrasaClassProvider>(
        context,
        listen: false,
      );
      if (classProvider.classes.isEmpty && classProvider.error == null) {
        classProvider.fetchClasses();
      }

      final studentProvider = Provider.of<StudentProvider>(
        context,
        listen: false,
      );
      if (studentProvider.students.isEmpty && studentProvider.error == null) {
        studentProvider.fetchStudents();
      }
    });
  }

  String _getLocalizedClassName(BuildContext context, MadrasaClass madrasaClass) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;

    String className;
    switch (languageCode) {
      case 'ur':
        className = madrasaClass.nameUr;
        break;
      case 'ar':
        className = madrasaClass.nameAr;
        break;
      case 'en':
      default:
        className = madrasaClass.nameEn;
    }

    if (className.trim().isEmpty) className = madrasaClass.nameEn;
    return className;
  }

  Future<void> _handleDeleteClass(
    BuildContext context,
    MadrasaClass madrasaClass,
    int studentCount,
    String className,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<MadrasaClassProvider>(context, listen: false);
    
    // Show a loading indicator while checking (optional, but good UX)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    
    final hasStudents = await provider.checkClassHasStudents(madrasaClass.id);
    
    if (context.mounted) {
      Navigator.pop(context); // Dismiss loading dialog
    }

    if (hasStudents) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Text(l10n.deleteClass),
            ],
          ),
          content: Text(l10n.cannotDeleteClassWithStudents(studentCount > 0 ? studentCount : 1)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      );
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteClass),
        content: Text(l10n.deleteClassConfirmation(className)),
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
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final success = await provider.deleteClass(madrasaClass.id);
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.classDeletedSuccess),
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

  Future<void> _showAddEditClassDialog(
    BuildContext context, {
    MadrasaClass? madrasaClass,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = madrasaClass != null;
    final formKey = GlobalKey<FormState>();

    final nameEnController = TextEditingController(text: madrasaClass?.nameEn ?? '');
    final nameUrController = TextEditingController(text: madrasaClass?.nameUr ?? '');
    final nameArController = TextEditingController(text: madrasaClass?.nameAr ?? '');
    final sortOrderController = TextEditingController(
      text: madrasaClass != null ? madrasaClass.sortOrder.toString() : '',
    );
    bool isActive = madrasaClass?.isActive ?? true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                isEditing ? l10n.editClass : l10n.addClass,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameEnController,
                          decoration: InputDecoration(
                            labelText: l10n.classNameEn,
                            prefixIcon: const Icon(Icons.class_outlined),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: nameUrController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: l10n.classNameUr,
                            prefixIcon: const Icon(Icons.translate),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: nameArController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: l10n.classNameAr,
                            prefixIcon: const Icon(Icons.language),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: sortOrderController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.sortOrder,
                            hintText: l10n.enterSortOrder,
                            prefixIcon: const Icon(Icons.sort),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            if (int.tryParse(val.trim()) == null) {
                              return l10n.invalidNumber;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: Text(l10n.active),
                          value: isActive,
                          onChanged: (newVal) {
                            setDialogState(() {
                              isActive = newVal;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final nameEn = nameEnController.text.trim();
                      final nameUr = nameUrController.text.trim();
                      final nameAr = nameArController.text.trim();
                      final sortOrder = int.parse(sortOrderController.text.trim());

                      final provider = Provider.of<MadrasaClassProvider>(
                        context,
                        listen: false,
                      );

                      Navigator.pop(dialogContext);

                      bool success;
                      if (isEditing) {
                        final updated = MadrasaClass(
                          id: madrasaClass.id,
                          nameEn: nameEn,
                          nameUr: nameUr,
                          nameAr: nameAr,
                          sortOrder: sortOrder,
                          isActive: isActive,
                          createdAt: madrasaClass.createdAt,
                        );
                        success = await provider.updateClass(updated);
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.classUpdatedSuccess),
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
                      } else {
                        final newClass = MadrasaClass(
                          id: '',
                          nameEn: nameEn,
                          nameUr: nameUr,
                          nameAr: nameAr,
                          sortOrder: sortOrder,
                          isActive: isActive,
                          createdAt: DateTime.now(),
                        );
                        success = await provider.addClass(newClass);
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.classAddedSuccess),
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
                    }
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.classes,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: l10n.addClass,
            onPressed: () => _showAddEditClassDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditClassDialog(context),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          l10n.addClass,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Consumer2<MadrasaClassProvider, StudentProvider>(
          builder: (context, classProvider, studentProvider, child) {
            if (classProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (classProvider.error != null) {
              return _buildErrorState(classProvider, l10n, isDark);
            }

            return _buildBody(classProvider, studentProvider, l10n, isDark);
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    MadrasaClassProvider classProvider,
    StudentProvider studentProvider,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final activeClasses = classProvider.classes
        .where((c) => c.isActive)
        .toList();

    // Calculate unassigned students
    final unassignedStudentsCount = studentProvider.students
        .where(
          (s) =>
              s.classId.isEmpty ||
              classProvider.getClassById(s.classId) == null,
        )
        .length;

    if (activeClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.class_outlined,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noClassesFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddEditClassDialog(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addClass),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async {
        await classProvider.fetchClasses();
        await studentProvider.fetchStudents();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (unassignedStudentsCount > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildUnassignedCard(
                  context,
                  unassignedStudentsCount,
                  l10n,
                  isDark,
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final madrasaClass = activeClasses[index];
                final studentCount = studentProvider.students
                    .where((s) => s.classId == madrasaClass.id)
                    .length;
                return _buildClassCard(
                  context,
                  madrasaClass,
                  studentCount,
                  l10n,
                  isDark,
                );
              }, childCount: activeClasses.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    MadrasaClassProvider provider,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 54, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.fetchClasses(),
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

  Widget _buildUnassignedCard(
    BuildContext context,
    int count,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.redAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      color: Colors.redAccent.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          debugPrint('StudentsScreen received classId: unassigned');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => StudentsScreen(
                classId: 'unassigned',
                className: l10n.unassignedStudents,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.unassignedStudents,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.unassignedStudentsSubtitle(count),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    MadrasaClass madrasaClass,
    int studentCount,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final className = _getLocalizedClassName(context, madrasaClass);

    return Card(
      elevation: isDark ? 2 : 4,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      color: Theme.of(context).cardColor,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              debugPrint('ClassesScreen selected classId: ${madrasaClass.id}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => StudentsScreen(
                    classId: madrasaClass.id,
                    className: className,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.class_,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    className,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$studentCount ${l10n.students.toLowerCase()}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: Directionality.of(context) == TextDirection.rtl ? null : 4,
            left: Directionality.of(context) == TextDirection.rtl ? 4 : null,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (action) {
                if (action == 'edit') {
                  _showAddEditClassDialog(context, madrasaClass: madrasaClass);
                } else if (action == 'delete') {
                  _handleDeleteClass(context, madrasaClass, studentCount, className);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.editClass),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(
                        l10n.deleteClass,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
