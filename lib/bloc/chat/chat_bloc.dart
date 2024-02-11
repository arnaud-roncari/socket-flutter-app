import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/message_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/repository/user_gateway.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserGateway userGateway;
  late ChatModel chat;
  late UserModel recipient;
  late UserModel sender;

  ChatBloc({required this.userGateway}) : super(ChatInitial()) {
    on<OnChatOpened>(_onChatOpened);
    on<OnCreateMessage>(_onCreateMessage);
    on<OnCreateMessageFailed>(_onCreateMessageFailed);
    on<OnCreatedMessageSuccess>(_onCreateMessageSuccess);
    on<OnNewMessage>(_onNewMessage);
    on<OnConnectedUser>(_onConnectedUser);
    on<OnDisconnectedUser>(_onDisconnectedUser);
    on<OnTyping>(_onTyping);
    on<OnUserTyping>(_onUserTyping);

    userGateway.onConnectedUser((userId) => add(OnConnectedUser(userId: userId)));
    userGateway.onUserTyping(
      (userId, chatId, isTyping) => add(
        OnUserTyping(
          userId: userId,
          chatId: chatId,
          isTyping: isTyping,
        ),
      ),
    );
    userGateway.onDisconnectedUser((userId) => add(OnDisconnectedUser(userId: userId)));
    userGateway.onNewMessage((message, chatId) => add(OnNewMessage(chatId: chatId, message: message)));
    userGateway.onCreateMessageResponse(
      onSuccess: (requestUuid, message, chatId) => add(
        OnCreatedMessageSuccess(
          requestUuid: requestUuid,
          chatId: chatId,
          message: message,
        ),
      ),
      onFailed: (String requestUuid, ApiException exception) => add(
        OnCreateMessageFailed(
          requestUuid: requestUuid,
          exception: exception,
        ),
      ),
    );
  }

  void _onChatOpened(OnChatOpened event, Emitter<ChatState> emit) {
    /// Make sure the reference is not linked, to avoid problem with socket events, such new-message.
    /// Which could display multiple times same message created or received.
    chat = ChatModel(
      users: List.from(event.chat.users),
      messages: List.from(event.chat.messages),
      id: event.chat.id,
    );
    recipient = event.recipient;
    sender = event.sender;
  }

  void _onCreateMessage(OnCreateMessage event, Emitter<ChatState> emit) {
    MessageModel message = MessageModel(
      userId: sender.id,
      text: event.text,
      createdAt: DateTime.now(),
      status: MessageStatus.loading,
      requestUuid: const Uuid().v4(),
    );
    chat.messages.add(message);
    // Reload front to clear the controller and make the message appears.
    emit(ChatInitial());
    userGateway.createMessage(
      requestUuid: message.requestUuid!,
      chatId: event.chat.id,
      text: message.text,
    );
  }

  void _onCreateMessageSuccess(OnCreatedMessageSuccess event, Emitter<ChatState> emit) {
    for (int i = 0; i < chat.messages.length; i++) {
      MessageModel message = chat.messages[i];
      if (message.requestUuid != null && message.requestUuid == event.requestUuid) {
        chat.messages[i] = event.message;
        break;
      }
    }
    emit(ChatInitial());
  }

  void _onCreateMessageFailed(OnCreateMessageFailed event, Emitter<ChatState> emit) {
    for (int i = 0; i < chat.messages.length; i++) {
      MessageModel message = chat.messages[i];
      if (message.requestUuid != null && message.requestUuid == event.requestUuid) {
        chat.messages[i].status = MessageStatus.failed;
        break;
      }
    }
    emit(ChatInitial());
  }

  void _onNewMessage(OnNewMessage event, Emitter<ChatState> emit) {
    /// Make sure message is linked to this chat.
    /// And also verify that we don't had 2 time the message, if it's from the sender.
    /// Since it's already added in OnCreateMessageSuccess.
    if (event.chatId == chat.id && event.message.userId != sender.id) {
      chat.messages.add(event.message);
    }
    emit(ChatInitial());
  }

  void _onConnectedUser(OnConnectedUser event, Emitter<ChatState> emit) {
    if (event.userId == recipient.id) {
      recipient.isConnected = true;
      emit(ChatInitial());
    }
  }

  void _onDisconnectedUser(OnDisconnectedUser event, Emitter<ChatState> emit) {
    if (event.userId == recipient.id) {
      recipient.isConnected = false;
      emit(ChatInitial());
    }
  }

  void _onTyping(OnTyping event, Emitter<ChatState> emit) {
    userGateway.typing(chatId: event.chat.id, isTyping: event.isTyping);
  }

  void _onUserTyping(OnUserTyping event, Emitter<ChatState> emit) {
    if (chat.id == event.chatId && recipient.id == event.userId) {
      recipient.isTyping = event.isTyping;
      emit(ChatInitial());
    }
  }
}
