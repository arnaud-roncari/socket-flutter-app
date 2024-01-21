part of 'create_chat_bloc.dart';

@immutable
sealed class CreateChatState {}

final class CreateChatInitial extends CreateChatState {}

final class CreateChatLoading extends CreateChatState {}

final class CreateChatFailure extends CreateChatState {
  final Object exception;

  CreateChatFailure({required this.exception});
}

final class CreateChatSuccess extends CreateChatState {
  final List<UserModel> users;

  CreateChatSuccess({required this.users});
}

final class CreatedChatSuccess extends CreateChatState {
  final ChatModel chat;
  final UserModel sender;
  final UserModel recipient;

  CreatedChatSuccess({required this.chat, required this.sender, required this.recipient});
}
