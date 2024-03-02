import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_flutter_app/bloc/auth/auth_bloc.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/bloc/create_chat/create_chat_bloc.dart';
import 'package:socket_flutter_app/bloc/home/home_bloc.dart';
import 'package:socket_flutter_app/repository/auth_repository.dart';
import 'package:socket_flutter_app/repository/user_gateway.dart';
import 'package:socket_flutter_app/repository/user_repository.dart';
import 'package:socket_flutter_app/services/firebase_service.dart';
import 'package:socket_flutter_app/ui/page/auth_page.dart';
import 'package:socket_flutter_app/ui/page/chat_page.dart';
import 'package:socket_flutter_app/ui/page/create_chat_page.dart';
import 'package:socket_flutter_app/ui/page/home_page.dart';
import 'package:socket_flutter_app/ui/page/login_page.dart';
import 'package:socket_flutter_app/ui/page/signup_page.dart';

class MyApp extends StatelessWidget {
  final bool isSession;
  const MyApp({super.key, required this.isSession});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<FlutterSecureStorage>(create: (context) => const FlutterSecureStorage()),
        RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
        RepositoryProvider<UserGateway>(create: (context) => UserGateway()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                localStorage: context.read<FlutterSecureStorage>(),
              ),
            ),
            BlocProvider(
              create: (_) => HomeBloc(
                userRepository: context.read<UserRepository>(),
                userGateway: context.read<UserGateway>(),
              ),
            ),
            BlocProvider(
              create: (_) => CreateChatBloc(
                userRepository: context.read<UserRepository>(),
                userGateway: context.read<UserGateway>(),
              ),
            ),
            BlocProvider(
              create: (_) => ChatBloc(
                userGateway: context.read<UserGateway>(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: FirebaseService.navigatorKey,
            title: 'Memoji',
            initialRoute: isSession ? "/home" : "/auth",
            routes: {
              '/auth': (context) => const AuthPage(),
              '/home': (context) => const HomePage(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/create-chat': (context) => const CreateChatPage(),
              '/chat': (context) => const ChatPage(),
            },
          ),
        );
      }),
    );
  }
}
