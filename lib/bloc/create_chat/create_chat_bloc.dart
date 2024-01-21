import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/repository/chat_repository.dart';
import 'package:socket_flutter_app/repository/user_repository.dart';

part 'create_chat_event.dart';
part 'create_chat_state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  UserRepository userRepository;
  ChatRepository chatRepository;

  CreateChatBloc({required this.userRepository, required this.chatRepository}) : super(CreateChatInitial()) {
    on<OnUsersFetched>(_onUsersFetched);
    on<OnChatCreated>(_onChatCreated);
  }

  void _onUsersFetched(OnUsersFetched event, Emitter<CreateChatState> emit) async {
    try {
      emit(CreateChatLoading());
      List<UserModel> users = await userRepository.getAllUsers();
      emit(CreateChatSuccess(users: users));
    } catch (exception) {
      emit(CreateChatFailure(exception: exception));
    }
  }

  void _onChatCreated(OnChatCreated event, Emitter<CreateChatState> emit) async {
    try {
      emit(CreateChatLoading());
      ChatModel chat = await chatRepository.createChat(recipient: event.recipient);
      emit(CreatedChatSuccess(chat: chat, sender: event.sender, recipient: event.recipient));
    } catch (exception) {
      emit(CreateChatFailure(exception: exception));
    }
  }
}
