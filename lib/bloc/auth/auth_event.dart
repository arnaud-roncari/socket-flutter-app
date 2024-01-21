part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class OnLoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  OnLoginButtonPressed({
    required this.username,
    required this.password,
  });
}

final class OnSignupButtonPressed extends AuthEvent {
  final String username;
  final String password;

  OnSignupButtonPressed({
    required this.username,
    required this.password,
  });
}
