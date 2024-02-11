import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/repository/user_gateway.dart';
import 'package:socket_flutter_app/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'create_chat_event.dart';
part 'create_chat_state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  UserRepository userRepository;
  UserGateway userGateway;
  UserModel? recipient;
  UserModel? sender;

  CreateChatBloc({required this.userRepository, required this.userGateway}) : super(CreateChatInitial()) {
    on<OnUsersFetched>(_onUsersFetched);
    on<OnCreateChat>(_onCreateChat);
    on<OnCreateChatSuccess>(_onCreateChatSuccess);
    on<OnCreateChatFailed>(_onCreateChatFailed);

    userGateway.onCreateChatResponse(
      onSuccess: (requestUuid, chat) => add(OnCreateChatSuccess(requestUuid: requestUuid, chat: chat)),
      onFailed: (requestUuid, exception) => add(OnCreateChatFailed(requestUuid: requestUuid, exception: exception)),
    );
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

  void _onCreateChatSuccess(OnCreateChatSuccess event, Emitter<CreateChatState> emit) {
    emit(OnChatCreatedSuccess(chat: event.chat, sender: sender!, recipient: recipient!));
    recipient = null;
    sender = null;
  }

  void _onCreateChatFailed(OnCreateChatFailed event, Emitter<CreateChatState> emit) {
    emit(CreateChatFailure(exception: event.exception));
    recipient = null;
    sender = null;
  }

  void _onCreateChat(OnCreateChat event, Emitter<CreateChatState> emit) async {
    try {
      emit(CreateChatLoading());

      /// Keep recipient and sender to be used in OnCreateChatResponse
      recipient = event.recipient;
      sender = event.sender;
      userGateway.createChat(requestUuid: const Uuid().v4(), recipient: event.recipient.id);
    } catch (exception) {
      emit(CreateChatFailure(exception: exception));
    }
  }
}
