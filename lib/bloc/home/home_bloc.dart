import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/repository/chat_repository.dart';
import 'package:socket_flutter_app/repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final ChatRepository chatRepository;
  late UserModel user;
  late List<ChatModel> chats;

  HomeBloc({
    required this.userRepository,
    required this.chatRepository,
  }) : super(HomeInitial()) {
    on<OnUserFetched>(_onUserFetched);
    on<OnCreateChatSuccess>(_onCreateChatSuccess);
  }

  void _onUserFetched(OnUserFetched event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      List futures = await Future.wait([
        userRepository.getUser(),
        chatRepository.getChats(),
      ]);
      user = futures[0];
      chats = futures[1];

      emit(HomeSuccess(user: user, chats: chats));
    } catch (exception) {
      emit(HomeFailure(exception: exception));
    }
  }

  void _onCreateChatSuccess(OnCreateChatSuccess event, Emitter<HomeState> emit) {
    chats.add(event.chat);
    emit(HomeSuccess(user: user, chats: chats));
  }
}
