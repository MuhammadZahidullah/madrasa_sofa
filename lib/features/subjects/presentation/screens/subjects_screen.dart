import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/subject.dart';
import '../providers/subject_provider.dart';
import 'add_edit_subject_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
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
      final subjectProvider = Provider.of<SubjectProvider>(
        context,
        listen: false,
      );
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

  String _getLocalizedSubjectName(BuildContext context, Subject subject) {
    final languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'ur':
        return subject.nameUr.trim().isNotEmpty
            ? subject.nameUr
            : subject.nameEn;
      case 'ar':
        return subject.nameAr.trim().isNotEmpty
            ? subject.nameAr
            : subject.nameEn;
      case 'en':
      default:
        return subject.nameEn.trim().isNotEmpty
            ? subject.nameEn
            : (subject.nameUr.trim().isNotEmpty
                ? subject.nameUr
                : subject.nameAr);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Subject subject) async {
    final l10n = AppLocalizations.of(context)!;
    final displayName = _getLocalizedSubjectName(context, subject);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteSubjectTitle),
        content: Text(l10n.deleteSubjectConfirmation(displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<SubjectProvider>(context, listen: false);
      final success = await provider.deleteSubject(subject.id);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.subjectDeletedSuccess),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<SubjectProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredSubjects = provider.subjects.where((subject) {
      if (_searchQuery.isEmpty) return true;
      final enMatch = subject.nameEn.toLowerCase().contains(_searchQuery);
      final urMatch = subject.nameUr.toLowerCase().contains(_searchQuery);
      final arMatch = subject.nameAr.toLowerCase().contains(_searchQuery);
      return enMatch || urMatch || arMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.subjects,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addSubject,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditSubjectScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchSubjects,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            ),
          ),

          // Body Content
          Expanded(
            child: Builder(
              builder: (context) {
                if (provider.isLoading && provider.subjects.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.subjects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.errorLoadingSubjects,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.fetchSubjects(),
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.subjects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color: isDark
                                ? Colors.grey[600]
                                : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noSubjectsYet,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AddEditSubjectScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addSubject),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (filteredSubjects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: isDark
                                ? Colors.grey[600]
                                : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noSubjectsFound,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchSubjects(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSubjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final subject = filteredSubjects[index];
                      return _buildSubjectCard(context, subject);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditSubjectScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizedName = _getLocalizedSubjectName(context, subject);

    // Prepare other name subtitles for clarity
    final currentLanguageCode = Localizations.localeOf(context).languageCode;
    final List<String> otherNames = [];
    if (currentLanguageCode != 'en' && subject.nameEn.isNotEmpty) {
      otherNames.add(subject.nameEn);
    }
    if (currentLanguageCode != 'ur' && subject.nameUr.isNotEmpty) {
      otherNames.add(subject.nameUr);
    }
    if (currentLanguageCode != 'ar' && subject.nameAr.isNotEmpty) {
      otherNames.add(subject.nameAr);
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: subject.isActive
                    ? AppTheme.primaryColor.withAlpha(25)
                    : Colors.grey.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book,
                color: subject.isActive
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.grey[500] : Colors.grey[600]),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Subject Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          localizedName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Active/Inactive Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: subject.isActive
                              ? Colors.green.withAlpha(25)
                              : Colors.grey.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: subject.isActive
                                ? Colors.green.withAlpha(80)
                                : Colors.grey.withAlpha(80),
                          ),
                        ),
                        child: Text(
                          subject.isActive ? l10n.active : l10n.inactive,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: subject.isActive
                                ? Colors.green[700]
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (otherNames.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      otherNames.join(' • '),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),

                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(l10n.edit),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditSubjectScreen(subject: subject),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: Text(l10n.delete),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => _confirmDelete(context, subject),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
