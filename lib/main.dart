import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_flutter_app/app.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// TODO Avant de finir la base du back, tester sur iPhone et régler les bug (clavier qui s'ouvre et qui cache)
/// Puis on fait un petit clean du projet
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the application oriention to portrait only.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Verify if an accessToken was stored.
  /// If there is, the user don't have to login.
  String? token = await const FlutterSecureStorage().read(key: LocalStorageKeys.jwt);

  /// Determine the first screens displayed.
  bool isSession = token != null && token.isNotEmpty;

  /// JWT is saved in ram, to be used later.
  kJwt = token;

  runApp(MyApp(isSession: isSession));
}
