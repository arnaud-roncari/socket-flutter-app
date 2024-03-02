part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class OnUserFetched extends HomeEvent {}

final class OnSocketInit extends HomeEvent {}

final class OnConnectedSocket extends HomeEvent {}

final class OnNewChat extends HomeEvent {
  final ChatModel chat;

  OnNewChat({required this.chat});
}

final class OnNewMessage extends HomeEvent {
  final MessageModel message;
  final String chatId;

  OnNewMessage({required this.message, required this.chatId});
}

final class OnConnectedUser extends HomeEvent {
  final String userId;

  OnConnectedUser({required this.userId});
}

final class OnConnectedUsers extends HomeEvent {
  final List<String> userIds;

  OnConnectedUsers({required this.userIds});
}

final class OnDisconnectedUser extends HomeEvent {
  final String userId;

  OnDisconnectedUser({required this.userId});
}

final class OnUserTyping extends HomeEvent {
  final String chatId;
  final String userId;
  final bool isTyping;

  OnUserTyping({required this.chatId, required this.userId, required this.isTyping});
}

final class OnMessageRead extends HomeEvent {
  final String chatId;
  final List<String> messageIds;

  OnMessageRead({required this.chatId, required this.messageIds});
}
