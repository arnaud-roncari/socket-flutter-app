import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_flutter_app/model/user_model.dart';

Future handleMessage(RemoteMessage? message) async {
  ChatModel chat = ChatModel.fromJson(jsonDecode(message!.data["chat"]));
  UserModel sender = UserModel.fromJson(jsonDecode(message.data["sender"]));
  UserModel recipient = UserModel.fromJson(jsonDecode(message.data["recipient"]));

  BuildContext? context = FirebaseService.navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  // Recipient and sender are reversed.
  context.read<ChatBloc>().add(OnChatOpened(recipient: sender, sender: recipient, chat: chat));
  FirebaseService.navigatorKey.currentState!.pushNamed("/chat");
}

void handleLocalNotification(NotificationResponse notification) {
  final RemoteMessage message = RemoteMessage.fromMap(jsonDecode(notification.payload!));
  handleMessage(message);
}

class FirebaseService {
  static FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static late FirebaseMessaging instance;
  static String? fcmToken;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    instance = FirebaseMessaging.instance;
    await instance.requestPermission();
    fcmToken = await instance.getToken();

    /// Initialize local notifications
    await localNotificationsPlugin.initialize(
      const InitializationSettings(iOS: DarwinInitializationSettings()),
      onDidReceiveBackgroundNotificationResponse: handleLocalNotification,
      onDidReceiveNotificationResponse: handleLocalNotification,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleMessage);

    /// Display notification while app is open.
    FirebaseMessaging.onMessage.listen((message) {
      if (kOpenedChatId != null) {
        return;
      }

      final RemoteNotification notification = message.notification!;
      localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(iOS: DarwinNotificationDetails()),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
}
