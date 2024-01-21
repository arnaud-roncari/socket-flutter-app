import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late ChatModel chat;
  late UserModel recipient;
  late UserModel sender;

  ChatBloc() : super(ChatInitial()) {
    on<OnChatOpened>(_onChatOpened);
  }

  void _onChatOpened(OnChatOpened event, Emitter<ChatState> emit) {
    chat = event.chat;
    recipient = event.recipient;
    sender = event.sender;
  }
}
