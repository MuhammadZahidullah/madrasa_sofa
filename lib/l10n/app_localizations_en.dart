// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Madrasa Sofa';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get students => 'Students';

  @override
  String get teachers => 'Teachers';

  @override
  String get classes => 'Classes';

  @override
  String get attendance => 'Attendance';

  @override
  String get results => 'Results';

  @override
  String get books => 'Books';

  @override
  String get fees => 'Fees';

  @override
  String get english => 'English';

  @override
  String get urdu => 'Urdu';

  @override
  String get arabic => 'Arabic';

  @override
  String get welcome => 'Welcome';

  @override
  String get signIn => 'Sign In';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get logout => 'Logout';

  @override
  String get loading => 'Loading';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get admin => 'Admin';

  @override
  String get teacher => 'Teacher';

  @override
  String get student => 'Student';

  @override
  String get accountDisabled => 'Account disabled';

  @override
  String get accountNotConfigured =>
      'Account profile not configured. Contact the administrator.';

  @override
  String get unknownRole => 'Unknown role';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get bookProgress => 'Book Progress';

  @override
  String get studentHistory => 'Student History';

  @override
  String get myStudents => 'My Students';

  @override
  String get myClasses => 'My Classes';

  @override
  String get takeAttendance => 'Take Attendance';

  @override
  String get enterMarks => 'Enter Marks';

  @override
  String get myAttendance => 'My Attendance';

  @override
  String get myResults => 'My Results';

  @override
  String get myProgress => 'My Progress';

  @override
  String get myHistory => 'My History';

  @override
  String get manageTeachers => 'Manage Teachers';

  @override
  String get manageStudents => 'Manage Students';

  @override
  String get manageClasses => 'Manage Classes';

  @override
  String get profileFetchFailed =>
      'Unable to load your account profile. Please try again or contact the administrator.';

  @override
  String get overviewSubtitle => 'Here\'s today\'s madrasa overview';

  @override
  String assalamuAlaikum(String name) {
    return 'Assalamu Alaikum, $name';
  }

  @override
  String get totalEnrolled => 'Total enrolled';

  @override
  String get activeTeachers => 'Active teachers';

  @override
  String get totalClassesSubtitle => 'Total classes';

  @override
  String get todaysAttendance => 'Today\'s attendance';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewAll => 'View All';

  @override
  String get addStudent => 'Add Student';

  @override
  String get addTeacher => 'Add Teacher';

  @override
  String get registerNewStudent => 'Register a new student';

  @override
  String get registerNewTeacher => 'Register a new teacher';

  @override
  String get management => 'Management';

  @override
  String get viewManageStudents => 'View and manage all students';

  @override
  String get viewManageTeachers => 'View and manage all teachers';

  @override
  String get manageClassesSections => 'Manage classes and sections';

  @override
  String get viewManageAttendance => 'View and manage attendance';

  @override
  String get manageExamResults => 'Manage exam results';

  @override
  String get trackBookProgress => 'Track book and lesson progress';

  @override
  String get manageFeeRecords => 'Manage fee records';

  @override
  String get homeNav => 'Home';

  @override
  String get notificationsNav => 'Notifications';

  @override
  String get profileNav => 'Profile';

  @override
  String get searchStudents => 'Search by name, father name, roll...';

  @override
  String get noStudentsFound => 'No students found';

  @override
  String get noStudentsYet => 'No students added yet';

  @override
  String get errorLoadingStudents => 'Failed to load students';

  @override
  String get retry => 'Retry';

  @override
  String get rollNumber => 'Roll Number';

  @override
  String get rollNumberPrefix => 'Roll #';

  @override
  String get fatherName => 'Father Name';

  @override
  String get classId => 'Class ID';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get addNewStudent => 'Add New Student';

  @override
  String get editStudent => 'Edit Student';

  @override
  String get studentName => 'Student Name';

  @override
  String get enterStudentName => 'Enter student name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get enterFatherName => 'Enter father\'s name';

  @override
  String get fatherNameRequired => 'Father\'s name is required';

  @override
  String get enterRollNumber => 'Enter roll number';

  @override
  String get rollNumberRequired => 'Roll number is required';

  @override
  String get enterClassId => 'Enter class ID';

  @override
  String get classIdRequired => 'Class ID is required';

  @override
  String get enterPhone => 'Enter phone (optional)';

  @override
  String get enterAddress => 'Enter address (optional)';

  @override
  String get status => 'Status';

  @override
  String get saveStudent => 'Save Student';

  @override
  String get updateStudent => 'Update Student';

  @override
  String get studentAddedSuccess => 'Student added successfully';

  @override
  String get studentUpdatedSuccess => 'Student updated successfully';

  @override
  String get studentDeletedSuccess => 'Student deleted successfully';

  @override
  String get deleteStudentTitle => 'Delete Student';

  @override
  String deleteStudentConfirmation(String name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get unassignedStudents => 'Unassigned Students';

  @override
  String unassignedStudentsSubtitle(int count) {
    return '$count students need a class';
  }

  @override
  String get noClassesFound => 'No classes found';

  @override
  String get selectClass => 'Select Class';

  @override
  String get addClass => 'Add Class';

  @override
  String get editClass => 'Edit Class';

  @override
  String get deleteClass => 'Delete Class';

  @override
  String deleteClassConfirmation(String name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get classNameEn => 'Class Name (English)';

  @override
  String get classNameUr => 'Class Name (Urdu)';

  @override
  String get classNameAr => 'Class Name (Arabic)';

  @override
  String get sortOrder => 'Sort Order';

  @override
  String get enterSortOrder => 'Enter sort order';

  @override
  String cannotDeleteClassWithStudents(int count) {
    return 'Cannot delete this class because $count students are enrolled in it. Reassign or remove the students first.';
  }

  @override
  String get classAddedSuccess => 'Class added successfully';

  @override
  String get classUpdatedSuccess => 'Class updated successfully';

  @override
  String get classDeletedSuccess => 'Class deleted successfully';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidNumber => 'Please enter a valid number';

  @override
  String get save => 'Save';

  @override
  String get classRequired => 'Class is required';

  @override
  String get noClassesAvailableCreateFirst =>
      'No active classes available. Please create a class first.';
}
