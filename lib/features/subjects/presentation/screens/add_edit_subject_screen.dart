import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import '../../domain/entities/subject.dart';
import '../providers/subject_provider.dart';

class AddEditSubjectScreen extends StatefulWidget {
  final Subject? subject;

  const AddEditSubjectScreen({super.key, this.subject});

  @override
  State<AddEditSubjectScreen> createState() => _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends State<AddEditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameEnController;
  late final TextEditingController _nameUrController;
  late final TextEditingController _nameArController;
  late bool _isActive;

  bool get _isEditing => widget.subject != null;

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _nameEnController = TextEditingController(text: s?.nameEn ?? '');
    _nameUrController = TextEditingController(text: s?.nameUr ?? '');
    _nameArController = TextEditingController(text: s?.nameAr ?? '');
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameUrController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<SubjectProvider>(context, listen: false);

    final subject = Subject(
      id: widget.subject?.id ?? '',
      nameEn: _nameEnController.text.trim(),
      nameUr: _nameUrController.text.trim(),
      nameAr: _nameArController.text.trim(),
      isActive: _isActive,
      createdAt: widget.subject?.createdAt ?? DateTime.now(),
    );

    final bool success;
    if (_isEditing) {
      success = await provider.updateSubject(subject);
    } else {
      success = await provider.addSubject(subject);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? l10n.subjectUpdatedSuccess : l10n.subjectAddedSuccess,
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      Navigator.pop(context, true);
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildCard(
    BuildContext context, {
    required List<Widget> children,
    String? title,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[200] : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<SubjectProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.editSubject : l10n.addSubject,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildCard(
                    context,
                    children: [
                      TextFormField(
                        controller: _nameEnController,
                        decoration: InputDecoration(
                          labelText: l10n.subjectNameEn,
                          hintText: l10n.enterSubjectNameEn,
                          prefixIcon: const Icon(Icons.menu_book_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameUrController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: l10n.subjectNameUr,
                          hintText: l10n.enterSubjectNameUr,
                          prefixIcon: const Icon(Icons.translate),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameArController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: l10n.subjectNameAr,
                          hintText: l10n.enterSubjectNameAr,
                          prefixIcon: const Icon(Icons.language),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    context,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.activeStatus,
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
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.save,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
