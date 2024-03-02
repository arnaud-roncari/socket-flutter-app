import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/message_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/repository/user_gateway.dart';
import 'package:socket_flutter_app/repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final UserGateway userGateway;
  late UserModel user;
  late List<ChatModel> chats;

  HomeBloc({
    required this.userRepository,
    required this.userGateway,
  }) : super(HomeInitial()) {
    on<OnUserFetched>(_onUserFetched);
    on<OnNewChat>(_onNewChat);
    on<OnSocketInit>(_onSocketInit);
    on<OnConnectedSocket>(_onConnectedSocket);
    on<OnNewMessage>(_onNewMessage);
    on<OnConnectedUser>(_onConnectedUser);
    on<OnConnectedUsers>(_onConnectedUsers);
    on<OnDisconnectedUser>(_onDisconnectedUser);
    on<OnUserTyping>(_onUserTyping);
    on<OnMessageRead>(_onMessageRead);

    userGateway.onConnect((data) => add(OnConnectedSocket()));
    userGateway.onUserTyping(
      (userId, chatId, isTyping) => add(
        OnUserTyping(
          userId: userId,
          chatId: chatId,
          isTyping: isTyping,
        ),
      ),
    );
    userGateway.onMessageRead(
      (chatId, messageIds) => add(
        OnMessageRead(
          chatId: chatId,
          messageIds: messageIds,
        ),
      ),
    );
    userGateway.onConnectedUser((userId) => add(OnConnectedUser(userId: userId)));
    userGateway.onConnectedUsers((userIds) => add(OnConnectedUsers(userIds: userIds)));
    userGateway.onDisconnectedUser((userId) => add(OnDisconnectedUser(userId: userId)));
    userGateway.onConnect((data) => add(OnConnectedSocket()));
    userGateway.onNewChat((chat) => add(OnNewChat(chat: chat)));
    userGateway.onNewMessage((message, chatId) => add(OnNewMessage(message: message, chatId: chatId)));
  }

  void _onSocketInit(OnSocketInit event, Emitter<HomeState> emit) async {
    userGateway.connect();
  }

  void _onConnectedSocket(OnConnectedSocket event, Emitter<HomeState> emit) {
    /// Only when connected, informations can be displayed on screen.
    emit(HomeSuccess(user: user, chats: chats));
  }

  ///
  void _onConnectedUser(OnConnectedUser event, Emitter<HomeState> emit) {
    /// Skip if it's sender id.
    if (event.userId == user.id) {
      return;
    }

    for (ChatModel chat in chats) {
      for (UserModel user in chat.users) {
        if (event.userId == user.id) {
          user.isConnected = true;
        }
      }
    }

    emit(HomeSuccess(user: user, chats: chats));
  }

  void _onConnectedUsers(OnConnectedUsers event, Emitter<HomeState> emit) {
    for (String id in event.userIds) {
      for (ChatModel chat in chats) {
        for (UserModel user in chat.users) {
          if (id == user.id) {
            user.isConnected = true;
          }
        }
      }
    }
    emit(HomeSuccess(user: user, chats: chats));
  }

  void _onDisconnectedUser(OnDisconnectedUser event, Emitter<HomeState> emit) {
    /// Skip if it's sender id.
    if (event.userId == user.id) {
      return;
    }

    for (ChatModel chat in chats) {
      for (UserModel user in chat.users) {
        if (event.userId == user.id) {
          user.isConnected = false;
        }
      }
    }

    emit(HomeSuccess(user: user, chats: chats));
  }

  void _onUserFetched(OnUserFetched event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      List futures = await Future.wait([
        userRepository.getUser(),
        userRepository.getChats(),
      ]);
      user = futures[0];
      chats = futures[1];

      /// Init socket connection
      add(OnSocketInit());
    } catch (exception) {
      emit(HomeFailure(exception: exception));
    }
  }

  void _onNewChat(OnNewChat event, Emitter<HomeState> emit) {
    chats.add(event.chat);
    emit(HomeSuccess(user: user, chats: chats));
  }

  void _onNewMessage(OnNewMessage event, Emitter<HomeState> emit) {
    for (ChatModel chat in chats) {
      if (chat.id == event.chatId) {
        chat.messages.add(event.message);
        break;
      }
    }
    emit(HomeSuccess(user: user, chats: chats));
  }

  /// Necessary, to know when you enter in a chat if user is typing.
  void _onUserTyping(OnUserTyping event, Emitter<HomeState> emit) {
    /// Skip if it's sender id.
    if (event.userId == user.id) {
      return;
    }

    for (ChatModel chat in chats) {
      for (UserModel user in chat.users) {
        if (event.userId == user.id) {
          user.isTyping = event.isTyping;
        }
      }
    }
  }

  /// Updarte read status
  void _onMessageRead(OnMessageRead event, Emitter<HomeState> emit) {
    late ChatModel chatToUpdate;
    for (ChatModel chat in chats) {
      if (chat.id == event.chatId) {
        chatToUpdate = chat;
      }
    }

    for (MessageModel message in chatToUpdate.messages) {
      for (String id in event.messageIds) {
        if (id == message.id) {
          message.hasBeenRead = true;
        }
      }
    }
    emit(HomeSuccess(user: user, chats: chats));
  }

  @override
  Future<void> close() {
    userGateway.dispose();
    return super.close();
  }
}
