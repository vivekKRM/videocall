class RegisterResponse {
  late int status;
  late String message;
  late String token;
  late UserData? data;

  RegisterResponse(
      {required this.status,
      required this.message,
      required this.token,
      required this.data});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'] ?? '';
    data = json['User Data'] != null ? new UserData.fromJson(json['User Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
     data['token'] = this.token;
    data['message'] = this.message;
    if (this.data != null) {
      data['User Data'] = this.data?.toJson();
    }
    return data;
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? secondaryEmail;
  final String? fcmToken;
  final String? deviceType;
  final String? appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String role;
  final bool? byAdmin;
  final int? eventId;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.secondaryEmail,
    required this.fcmToken,
    required this.deviceType,
    required this.appVersion,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.byAdmin,
    required this.eventId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      secondaryEmail: json['secondary_email'],
      fcmToken: json['fcm_token'],
      deviceType: json['device_type'],
      appVersion: json['app_version'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      role: json['role'],
      byAdmin: json['by_admin'],
      eventId: json['event_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'secondary_email': secondaryEmail,
      'fcm_token': fcmToken,
      'device_type': deviceType,
      'app_version': appVersion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role,
      'by_admin': byAdmin,
      'event_id': eventId,
    };
  }
}
