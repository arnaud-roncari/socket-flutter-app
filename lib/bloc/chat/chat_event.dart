part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class OnChatOpened extends ChatEvent {
  final ChatModel chat;
  final UserModel recipient;
  final UserModel sender;

  OnChatOpened({required this.recipient, required this.sender, required this.chat});
}

class OnChatClosed extends ChatEvent {}

class OnCreateMessage extends ChatEvent {
  final String text;
  final ChatModel chat;

  OnCreateMessage({required this.text, required this.chat});
}

class OnCreatedMessageSuccess extends ChatEvent {
  final String requestUuid;
  final String chatId;
  final MessageModel message;

  OnCreatedMessageSuccess({required this.requestUuid, required this.chatId, required this.message});
}

class OnNewMessage extends ChatEvent {
  final String chatId;
  final MessageModel message;

  OnNewMessage({required this.chatId, required this.message});
}

class OnCreateMessageFailed extends ChatEvent {
  final String requestUuid;
  final ApiException exception;

  OnCreateMessageFailed({required this.requestUuid, required this.exception});
}

final class OnConnectedUser extends ChatEvent {
  final String userId;

  OnConnectedUser({required this.userId});
}

final class OnDisconnectedUser extends ChatEvent {
  final String userId;

  OnDisconnectedUser({required this.userId});
}

final class OnTyping extends ChatEvent {
  final ChatModel chat;
  final bool isTyping;

  OnTyping({required this.chat, required this.isTyping});
}

final class OnUserTyping extends ChatEvent {
  final String chatId;
  final String userId;
  final bool isTyping;

  OnUserTyping({required this.chatId, required this.userId, required this.isTyping});
}
