// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مدرسة صفا';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get students => 'الطلاب';

  @override
  String get teachers => 'المعلمون';

  @override
  String get classes => 'الفصول';

  @override
  String get attendance => 'الحضور';

  @override
  String get results => 'النتائج';

  @override
  String get books => 'الكتب';

  @override
  String get fees => 'الرسوم';

  @override
  String get english => 'الإنجليزية';

  @override
  String get urdu => 'الأردية';

  @override
  String get arabic => 'العربية';

  @override
  String get welcome => 'مرحباً';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidCredentials => 'بيانات الاعتماد غير صالحة';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get loading => 'جاري التحميل';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get admin => 'مسؤول';

  @override
  String get teacher => 'معلم';

  @override
  String get student => 'طالب';

  @override
  String get accountDisabled => 'الحساب معطل';

  @override
  String get accountNotConfigured =>
      'لم يتم تكوين ملف تعريف الحساب. اتصل بالمسؤول.';

  @override
  String get unknownRole => 'دور غير معروف';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get bookProgress => 'تقدم الكتاب';

  @override
  String get studentHistory => 'تاريخ الطالب';

  @override
  String get myStudents => 'طُلابي';

  @override
  String get myClasses => 'فصولي';

  @override
  String get takeAttendance => 'أخذ الحضور';

  @override
  String get enterMarks => 'إدخال الدرجات';

  @override
  String get myAttendance => 'حضوري';

  @override
  String get myResults => 'نتائجي';

  @override
  String get myProgress => 'تقدمي';

  @override
  String get myHistory => 'تاريخي';

  @override
  String get manageTeachers => 'إدارة المعلمين';

  @override
  String get manageStudents => 'إدارة الطلاب';

  @override
  String get manageClasses => 'إدارة الفصول';

  @override
  String get profileFetchFailed =>
      'تعذر تحميل ملف تعريف الحساب الخاص بك. يرجى المحاولة مرة أخرى أو الاتصال بالمسؤول.';

  @override
  String get overviewSubtitle => 'إليك نظرة عامة على المدرسة اليوم';

  @override
  String assalamuAlaikum(String name) {
    return 'السلام عليكم يا $name';
  }

  @override
  String get totalEnrolled => 'إجمالي المسجلين';

  @override
  String get activeTeachers => 'المعلمون النشطون';

  @override
  String get totalClassesSubtitle => 'إجمالي الفصول';

  @override
  String get todaysAttendance => 'حضور اليوم';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get addStudent => 'إضافة طالب';

  @override
  String get addTeacher => 'إضافة معلم';

  @override
  String get registerNewStudent => 'تسجيل طالب جديد';

  @override
  String get registerNewTeacher => 'تسجيل معلم جديد';

  @override
  String get management => 'الإدارة';

  @override
  String get viewManageStudents => 'عرض وإدارة جميع الطلاب';

  @override
  String get viewManageTeachers => 'عرض وإدارة جميع المعلمين';

  @override
  String get manageClassesSections => 'إدارة الفصول والأقسام';

  @override
  String get viewManageAttendance => 'عرض وإدارة الحضور';

  @override
  String get manageExamResults => 'إدارة نتائج الامتحانات';

  @override
  String get trackBookProgress => 'تتبع تقدم الكتب والدروس';

  @override
  String get manageFeeRecords => 'إدارة سجلات الرسوم';

  @override
  String get homeNav => 'الرئيسية';

  @override
  String get notificationsNav => 'الإشعارات';

  @override
  String get profileNav => 'الملف الشخصي';

  @override
  String get searchStudents => 'البحث بالاسم، اسم الأب، رقم القيد...';

  @override
  String get noStudentsFound => 'لم يتم العثور على طلاب';

  @override
  String get noStudentsYet => 'لم تتم إضافة أي طالب حتى الآن';

  @override
  String get errorLoadingStudents => 'فشل في تحميل الطلاب';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get rollNumber => 'رقم القيد';

  @override
  String get rollNumberPrefix => 'رقم: ';

  @override
  String get fatherName => 'اسم الأب';

  @override
  String get classId => 'معرف الفصل';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get phone => 'الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get addNewStudent => 'إضافة طالب جديد';

  @override
  String get editStudent => 'تعديل بيانات الطالب';

  @override
  String get studentName => 'اسم الطالب';

  @override
  String get enterStudentName => 'أدخل اسم الطالب';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get enterFatherName => 'أدخل اسم الأب';

  @override
  String get fatherNameRequired => 'اسم الأب مطلوب';

  @override
  String get enterRollNumber => 'أدخل رقم القيد';

  @override
  String get rollNumberRequired => 'رقم القيد مطلوب';

  @override
  String get enterClassId => 'أدخل معرف الفصل';

  @override
  String get classIdRequired => 'معرف الفصل مطلوب';

  @override
  String get enterPhone => 'أدخل رقم الهاتف (اختياري)';

  @override
  String get enterAddress => 'أدخل العنوان (اختياري)';

  @override
  String get status => 'الحالة';

  @override
  String get saveStudent => 'حفظ الطالب';

  @override
  String get updateStudent => 'تحديث بيانات الطالب';

  @override
  String get studentAddedSuccess => 'تمت إضافة الطالب بنجاح';

  @override
  String get studentUpdatedSuccess => 'تم تحديث بيانات الطالب بنجاح';

  @override
  String get studentDeletedSuccess => 'تم حذف الطالب بنجاح';

  @override
  String get deleteStudentTitle => 'حذف الطالب';

  @override
  String deleteStudentConfirmation(String name) {
    return 'هل أنت متأكد أنك تريد حذف $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get unassignedStudents => 'طلاب غير معينين';

  @override
  String unassignedStudentsSubtitle(int count) {
    return '$count طلاب يحتاجون إلى فصل';
  }

  @override
  String get noClassesFound => 'لم يتم العثور على فصول';

  @override
  String get selectClass => 'حدد الفصل';

  @override
  String get addClass => 'إضافة فصل';

  @override
  String get editClass => 'تعديل الفصل';

  @override
  String get deleteClass => 'حذف الفصل';

  @override
  String deleteClassConfirmation(String name) {
    return 'هل أنت متأكد أنك تريد حذف $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get classNameEn => 'اسم الفصل (بالإنجليزية)';

  @override
  String get classNameUr => 'اسم الفصل (بالأردية)';

  @override
  String get classNameAr => 'اسم الفصل (بالعربية)';

  @override
  String get sortOrder => 'ترتيب العرض';

  @override
  String get enterSortOrder => 'أدخل ترتيب العرض';

  @override
  String cannotDeleteClassWithStudents(int count) {
    return 'لا يمكن حذف هذا الفصل لأن هناك $count طالباً مسجلين فيه. يرجى نقل الطلاب أولاً.';
  }

  @override
  String get classAddedSuccess => 'تمت إضافة الفصل بنجاح';

  @override
  String get classUpdatedSuccess => 'تم تحديث الفصل بنجاح';

  @override
  String get classDeletedSuccess => 'تم حذف الفصل بنجاح';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidNumber => 'يرجى إدخال رقم صحيح';

  @override
  String get save => 'حفظ';

  @override
  String get classRequired => 'الفصل مطلوب';

  @override
  String get noClassesAvailableCreateFirst =>
      'لا توجد فصول دراسية متاحة. يرجى إنشاء فصل أولاً.';
}
