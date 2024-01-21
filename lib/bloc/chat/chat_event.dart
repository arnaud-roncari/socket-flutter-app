part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class OnChatOpened extends ChatEvent {
  final ChatModel chat;
  final UserModel recipient;
  final UserModel sender;

  OnChatOpened({required this.recipient, required this.sender, required this.chat});
}
