part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthFailure extends AuthState {
  final Object exception;

  AuthFailure({required this.exception});
}

final class AuthSuccess extends AuthState {}

final class AuthLoading extends AuthState {}
