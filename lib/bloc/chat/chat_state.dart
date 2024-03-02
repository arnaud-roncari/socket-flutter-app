part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatOpened extends ChatState {}

final class ChatClosed extends ChatState {}
