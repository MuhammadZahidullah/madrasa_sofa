import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ur'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Madrasa Sofa'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get fees;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account disabled'**
  String get accountDisabled;

  /// No description provided for @accountNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Account profile not configured. Contact the administrator.'**
  String get accountNotConfigured;

  /// No description provided for @unknownRole.
  ///
  /// In en, this message translates to:
  /// **'Unknown role'**
  String get unknownRole;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @bookProgress.
  ///
  /// In en, this message translates to:
  /// **'Book Progress'**
  String get bookProgress;

  /// No description provided for @studentHistory.
  ///
  /// In en, this message translates to:
  /// **'Student History'**
  String get studentHistory;

  /// No description provided for @myStudents.
  ///
  /// In en, this message translates to:
  /// **'My Students'**
  String get myStudents;

  /// No description provided for @myClasses.
  ///
  /// In en, this message translates to:
  /// **'My Classes'**
  String get myClasses;

  /// No description provided for @takeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Take Attendance'**
  String get takeAttendance;

  /// No description provided for @enterMarks.
  ///
  /// In en, this message translates to:
  /// **'Enter Marks'**
  String get enterMarks;

  /// No description provided for @myAttendance.
  ///
  /// In en, this message translates to:
  /// **'My Attendance'**
  String get myAttendance;

  /// No description provided for @myResults.
  ///
  /// In en, this message translates to:
  /// **'My Results'**
  String get myResults;

  /// No description provided for @myProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get myProgress;

  /// No description provided for @myHistory.
  ///
  /// In en, this message translates to:
  /// **'My History'**
  String get myHistory;

  /// No description provided for @manageTeachers.
  ///
  /// In en, this message translates to:
  /// **'Manage Teachers'**
  String get manageTeachers;

  /// No description provided for @manageStudents.
  ///
  /// In en, this message translates to:
  /// **'Manage Students'**
  String get manageStudents;

  /// No description provided for @manageClasses.
  ///
  /// In en, this message translates to:
  /// **'Manage Classes'**
  String get manageClasses;

  /// No description provided for @profileFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your account profile. Please try again or contact the administrator.'**
  String get profileFetchFailed;

  /// No description provided for @overviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s today\'s madrasa overview'**
  String get overviewSubtitle;

  /// No description provided for @assalamuAlaikum.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum, {name}'**
  String assalamuAlaikum(String name);

  /// No description provided for @totalEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Total enrolled'**
  String get totalEnrolled;

  /// No description provided for @activeTeachers.
  ///
  /// In en, this message translates to:
  /// **'Active teachers'**
  String get activeTeachers;

  /// No description provided for @totalClassesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total classes'**
  String get totalClassesSubtitle;

  /// No description provided for @todaysAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get todaysAttendance;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @addStudent.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudent;

  /// No description provided for @addTeacher.
  ///
  /// In en, this message translates to:
  /// **'Add Teacher'**
  String get addTeacher;

  /// No description provided for @registerNewStudent.
  ///
  /// In en, this message translates to:
  /// **'Register a new student'**
  String get registerNewStudent;

  /// No description provided for @registerNewTeacher.
  ///
  /// In en, this message translates to:
  /// **'Register a new teacher'**
  String get registerNewTeacher;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @viewManageStudents.
  ///
  /// In en, this message translates to:
  /// **'View and manage all students'**
  String get viewManageStudents;

  /// No description provided for @viewManageTeachers.
  ///
  /// In en, this message translates to:
  /// **'View and manage all teachers'**
  String get viewManageTeachers;

  /// No description provided for @manageClassesSections.
  ///
  /// In en, this message translates to:
  /// **'Manage classes and sections'**
  String get manageClassesSections;

  /// No description provided for @viewManageAttendance.
  ///
  /// In en, this message translates to:
  /// **'View and manage attendance'**
  String get viewManageAttendance;

  /// No description provided for @manageExamResults.
  ///
  /// In en, this message translates to:
  /// **'Manage exam results'**
  String get manageExamResults;

  /// No description provided for @trackBookProgress.
  ///
  /// In en, this message translates to:
  /// **'Track book and lesson progress'**
  String get trackBookProgress;

  /// No description provided for @manageFeeRecords.
  ///
  /// In en, this message translates to:
  /// **'Manage fee records'**
  String get manageFeeRecords;

  /// No description provided for @homeNav.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNav;

  /// No description provided for @notificationsNav.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsNav;

  /// No description provided for @profileNav.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileNav;

  /// No description provided for @searchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search by name, father name, roll...'**
  String get searchStudents;

  /// No description provided for @noStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No students found'**
  String get noStudentsFound;

  /// No description provided for @noStudentsYet.
  ///
  /// In en, this message translates to:
  /// **'No students added yet'**
  String get noStudentsYet;

  /// No description provided for @errorLoadingStudents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load students'**
  String get errorLoadingStudents;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @rollNumber.
  ///
  /// In en, this message translates to:
  /// **'Roll Number'**
  String get rollNumber;

  /// No description provided for @rollNumberPrefix.
  ///
  /// In en, this message translates to:
  /// **'Roll #'**
  String get rollNumberPrefix;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Father Name'**
  String get fatherName;

  /// No description provided for @classId.
  ///
  /// In en, this message translates to:
  /// **'Class ID'**
  String get classId;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addNewStudent.
  ///
  /// In en, this message translates to:
  /// **'Add New Student'**
  String get addNewStudent;

  /// No description provided for @editStudent.
  ///
  /// In en, this message translates to:
  /// **'Edit Student'**
  String get editStudent;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentName;

  /// No description provided for @enterStudentName.
  ///
  /// In en, this message translates to:
  /// **'Enter student name'**
  String get enterStudentName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @enterFatherName.
  ///
  /// In en, this message translates to:
  /// **'Enter father\'s name'**
  String get enterFatherName;

  /// No description provided for @fatherNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Father\'s name is required'**
  String get fatherNameRequired;

  /// No description provided for @enterRollNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter roll number'**
  String get enterRollNumber;

  /// No description provided for @rollNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Roll number is required'**
  String get rollNumberRequired;

  /// No description provided for @enterClassId.
  ///
  /// In en, this message translates to:
  /// **'Enter class ID'**
  String get enterClassId;

  /// No description provided for @classIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Class ID is required'**
  String get classIdRequired;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone (optional)'**
  String get enterPhone;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address (optional)'**
  String get enterAddress;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @saveStudent.
  ///
  /// In en, this message translates to:
  /// **'Save Student'**
  String get saveStudent;

  /// No description provided for @updateStudent.
  ///
  /// In en, this message translates to:
  /// **'Update Student'**
  String get updateStudent;

  /// No description provided for @studentAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Student added successfully'**
  String get studentAddedSuccess;

  /// No description provided for @studentUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Student updated successfully'**
  String get studentUpdatedSuccess;

  /// No description provided for @studentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Student deleted successfully'**
  String get studentDeletedSuccess;

  /// No description provided for @deleteStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Student'**
  String get deleteStudentTitle;

  /// No description provided for @deleteStudentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deleteStudentConfirmation(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @unassignedStudents.
  ///
  /// In en, this message translates to:
  /// **'Unassigned Students'**
  String get unassignedStudents;

  /// No description provided for @unassignedStudentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} students need a class'**
  String unassignedStudentsSubtitle(int count);

  /// No description provided for @noClassesFound.
  ///
  /// In en, this message translates to:
  /// **'No classes found'**
  String get noClassesFound;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selectClass;

  /// No description provided for @addClass.
  ///
  /// In en, this message translates to:
  /// **'Add Class'**
  String get addClass;

  /// No description provided for @editClass.
  ///
  /// In en, this message translates to:
  /// **'Edit Class'**
  String get editClass;

  /// No description provided for @deleteClass.
  ///
  /// In en, this message translates to:
  /// **'Delete Class'**
  String get deleteClass;

  /// No description provided for @deleteClassConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deleteClassConfirmation(String name);

  /// No description provided for @classNameEn.
  ///
  /// In en, this message translates to:
  /// **'Class Name (English)'**
  String get classNameEn;

  /// No description provided for @classNameUr.
  ///
  /// In en, this message translates to:
  /// **'Class Name (Urdu)'**
  String get classNameUr;

  /// No description provided for @classNameAr.
  ///
  /// In en, this message translates to:
  /// **'Class Name (Arabic)'**
  String get classNameAr;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrder;

  /// No description provided for @enterSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Enter sort order'**
  String get enterSortOrder;

  /// No description provided for @cannotDeleteClassWithStudents.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete this class because {count} students are enrolled in it. Reassign or remove the students first.'**
  String cannotDeleteClassWithStudents(int count);

  /// No description provided for @classAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class added successfully'**
  String get classAddedSuccess;

  /// No description provided for @classUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class updated successfully'**
  String get classUpdatedSuccess;

  /// No description provided for @classDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class deleted successfully'**
  String get classDeletedSuccess;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumber;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @classRequired.
  ///
  /// In en, this message translates to:
  /// **'Class is required'**
  String get classRequired;

  /// No description provided for @noClassesAvailableCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No active classes available. Please create a class first.'**
  String get noClassesAvailableCreateFirst;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
