part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final UserModel user;
  final List<ChatModel> chats;

  HomeSuccess({required this.user, required this.chats});
}

final class HomeFailure extends HomeState {
  final Object exception;

  HomeFailure({required this.exception});
}
