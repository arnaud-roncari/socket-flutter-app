part of 'create_chat_bloc.dart';

@immutable
sealed class CreateChatEvent {}

class OnUsersFetched extends CreateChatEvent {}

class OnCreateChat extends CreateChatEvent {
  final UserModel recipient;
  final UserModel sender;

  OnCreateChat({required this.recipient, required this.sender});
}

class OnCreateChatSuccess extends CreateChatEvent {
  final String requestUuid;
  final ChatModel chat;

  OnCreateChatSuccess({required this.requestUuid, required this.chat});
}

class OnCreateChatFailed extends CreateChatEvent {
  final String requestUuid;
  final ApiException exception;

  OnCreateChatFailed({required this.requestUuid, required this.exception});
}
