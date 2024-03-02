import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/repository/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/services/firebase_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage localStorage;

  AuthBloc({
    required this.authRepository,
    required this.localStorage,
  }) : super(AuthInitial()) {
    on<OnLoginButtonPressed>(_onLoginButtonPressed);
    on<OnSignupButtonPressed>(_onSignupButtonPressed);
  }

  void _onLoginButtonPressed(OnLoginButtonPressed event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      kJwt = await authRepository.login(
        username: event.username,
        password: event.password,
        fcmToken: FirebaseService.fcmToken,
      );
      await localStorage.write(key: LocalStorageKeys.jwt, value: kJwt);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(exception: e));
    }
  }

  void _onSignupButtonPressed(OnSignupButtonPressed event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      kJwt = await authRepository.signup(
        username: event.username,
        password: event.password,
        fcmToken: FirebaseService.fcmToken,
      );
      await localStorage.write(key: LocalStorageKeys.jwt, value: kJwt);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(exception: e));
    }
  }
}
