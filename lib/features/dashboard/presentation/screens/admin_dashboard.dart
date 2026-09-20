import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/features/auth/presentation/providers/auth_provider.dart';
import 'package:madrasa_soffa/core/localization/locale_provider.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/widgets/admin_stat_card.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/widgets/management_tile.dart';
import 'package:madrasa_soffa/core/theme/app_theme.dart';
import 'package:madrasa_soffa/features/classes/presentation/screens/classes_screen.dart';
import 'package:madrasa_soffa/features/students/presentation/screens/students_screen.dart';
import 'package:madrasa_soffa/features/students/presentation/screens/add_edit_student_screen.dart';
import 'package:madrasa_soffa/features/teachers/presentation/screens/teachers_screen.dart';
import 'package:madrasa_soffa/features/teachers/presentation/screens/add_edit_teacher_screen.dart';
import 'package:madrasa_soffa/features/subjects/presentation/screens/subjects_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.appUser;
    final userName = user?.name.isNotEmpty == true ? user!.name : l10n.admin;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mosque, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Madrasa Sofa',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          _buildLanguageSelector(context),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.assalamuAlaikum(userName),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.overviewSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  AdminStatCard(
                    title: l10n.students,
                    subtitle: l10n.totalEnrolled,
                    value: '0',
                    icon: Icons.people_alt,
                    accentColor: AppTheme.primaryColor,
                  ),
                  AdminStatCard(
                    title: l10n.teachers,
                    subtitle: l10n.activeTeachers,
                    value: '0',
                    icon: Icons.school,
                    accentColor: AppTheme.secondaryAccent,
                  ),
                  AdminStatCard(
                    title: l10n.classes,
                    subtitle: l10n.totalClassesSubtitle,
                    value: '0',
                    icon: Icons.menu_book,
                    accentColor: Colors.orange,
                  ),
                  AdminStatCard(
                    title: l10n.attendance,
                    subtitle: l10n.todaysAttendance,
                    value: '--',
                    icon: Icons.trending_up,
                    accentColor: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(
                context,
                l10n.quickActions,
                true,
                l10n.viewAll,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      title: l10n.addStudent,
                      subtitle: l10n.registerNewStudent,
                      icon: Icons.add,
                      accentColor: AppTheme.primaryColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditStudentScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionCard(
                      title: l10n.addTeacher,
                      subtitle: l10n.registerNewTeacher,
                      icon: Icons.add,
                      accentColor: AppTheme.secondaryAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditTeacherScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(context, l10n.management, false, ''),
              const SizedBox(height: 12),
              ManagementTile(
                title: l10n.students,
                subtitle: l10n.viewManageStudents,
                icon: Icons.people,
                iconColor: AppTheme.primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentsScreen()),
                ),
              ),
              ManagementTile(
                title: l10n.teachers,
                subtitle: l10n.viewManageTeachers,
                icon: Icons.school,
                iconColor: AppTheme.secondaryAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeachersScreen()),
                ),
              ),
              ManagementTile(
                title: l10n.classes,
                subtitle: l10n.manageClassesSections,
                icon: Icons.class_,
                iconColor: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClassesScreen()),
                ),
              ),
              ManagementTile(
                title: l10n.subjects,
                subtitle: l10n.viewManageSubjects,
                icon: Icons.menu_book,
                iconColor: Colors.indigo,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubjectsScreen()),
                ),
              ),
              ManagementTile(
                title: l10n.attendance,
                subtitle: l10n.viewManageAttendance,
                icon: Icons.calendar_today,
                iconColor: Colors.blue,
                onTap: () => _showComingSoon(context),
              ),
              ManagementTile(
                title: l10n.results,
                subtitle: l10n.manageExamResults,
                icon: Icons.description,
                iconColor: Colors.redAccent,
                onTap: () => _showComingSoon(context),
              ),
              ManagementTile(
                title: l10n.bookProgress,
                subtitle: l10n.trackBookProgress,
                icon: Icons.menu_book,
                iconColor: Colors.teal,
                onTap: () => _showComingSoon(context),
              ),
              ManagementTile(
                title: l10n.fees,
                subtitle: l10n.manageFeeRecords,
                icon: Icons.account_balance_wallet,
                iconColor: Colors.amber.shade700,
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homeNav,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_none),
            label: l10n.notificationsNav,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.profileNav,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    bool showViewAll,
    String viewAllText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (showViewAll)
          InkWell(
            onTap: () => _showComingSoon(context),
            child: Row(
              children: [
                Text(
                  viewAllText,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return PopupMenuButton<Locale>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16),
            const SizedBox(width: 4),
            Text(
              localeProvider.locale.languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      onSelected: (Locale locale) {
        localeProvider.setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem<Locale>(value: Locale('ur'), child: Text('اردو')),
        const PopupMenuItem<Locale>(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }
}
