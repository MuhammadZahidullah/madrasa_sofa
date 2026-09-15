import 'package:madrasa_soffa/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  AppUserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    bool parsedIsActive = false;
    if (json['isActive'] != null) {
      if (json['isActive'] is bool) {
        parsedIsActive = json['isActive'];
      } else if (json['isActive'] is String) {
        parsedIsActive = (json['isActive'] as String).toLowerCase() == 'true';
      }
    }
    
    return AppUserModel(
      uid: json['uid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isActive: parsedIsActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
    };
  }
}
