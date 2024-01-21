part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class OnUserFetched extends HomeEvent {}

final class OnCreateChatSuccess extends HomeEvent {
  final ChatModel chat;

  OnCreateChatSuccess({required this.chat});
}
