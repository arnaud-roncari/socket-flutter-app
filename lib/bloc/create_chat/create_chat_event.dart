part of 'create_chat_bloc.dart';

@immutable
sealed class CreateChatEvent {}

class OnUsersFetched extends CreateChatEvent {}

class OnChatCreated extends CreateChatEvent {
  final UserModel recipient;
  final UserModel sender;

  OnChatCreated({required this.recipient, required this.sender});
}
