import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String? dateOfBirth; // ISO date string YYYY-MM-DD
  final String businessName;
  final String email;
  final String password;
  final String? phone;
  const AuthSignUpRequested({
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    required this.businessName,
    required this.email,
    required this.password,
    this.phone,
  });
  @override
  List<Object?> get props =>
      [firstName, lastName, dateOfBirth, businessName, email, password, phone];
}

class AuthOtpVerifyRequested extends AuthEvent {
  final String email;
  final String otp;
  const AuthOtpVerifyRequested({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  const AuthResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [email, otp, newPassword];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
