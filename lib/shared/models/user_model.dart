import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? image;
  final String? dateOfBirth; // ISO date string YYYY-MM-DD
  // Role-separation signals (present when sourced from /users/me).
  final bool hasVendorProfile;
  final bool clientOnboarded;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.image,
    this.dateOfBirth,
    this.hasVendorProfile = false,
    this.clientOnboarded = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final clientProfile = json['clientProfile'];
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'vendor',
      image: json['image'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      hasVendorProfile: json['vendorProfile'] != null,
      clientOnboarded:
          clientProfile is Map && clientProfile['onboardingComplete'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'image': image,
        'dateOfBirth': dateOfBirth,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? image,
    String? dateOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      image: image ?? this.image,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, phone, role, image, dateOfBirth, hasVendorProfile, clientOnboarded];
}
