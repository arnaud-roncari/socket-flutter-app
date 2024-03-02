import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class UserGateway {
  late Socket _socket;

  UserGateway() {
    _socket = io(
      "$kWsUrl/user",
      OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"Authorization": "Bearer $kJwt"})
          .disableAutoConnect()
          .build(),
    );
  }

  void onNewChat(void Function(ChatModel) handler) {
    _socket.on("new-chat", (data) {
      handler(ChatModel.fromJson(data));
    });
  }

  /// Received each time a user is connected
  void onConnectedUser(void Function(String userId) handler) {
    _socket.on("connected-user", (data) {
      handler(data["id"]);
    });
  }

  /// Received onced. Inform which users is connected.
  void onConnectedUsers(void Function(List<String> userIds) handler) {
    _socket.on("connected-users", (data) {
      handler(List<String>.from(data["ids"]));
    });
  }

  void onDisconnectedUser(void Function(String userId) handler) {
    _socket.on("disconnected-user", (data) {
      handler(data["id"]);
    });
  }

  void onNewMessage(void Function(MessageModel message, String chatId) handler) {
    _socket.on("new-message", (data) {
      handler(
        MessageModel.fromJson(data),
        data["chat_id"],
      );
    });
  }

  /// Received each time a user is writing
  void onUserTyping(void Function(String userId, String chatId, bool isTyping) handler) {
    _socket.on("user-typing", (data) {
      handler(
        data["user_id"],
        data["chat_id"],
        data["is_typing"],
      );
    });
  }

  void onMessageRead(void Function(String chatId, List<String> messageIds) handler) {
    _socket.on("read-messages-response", (data) {
      handler(
        data["data"]["chat_id"],
        List<String>.from(data["data"]["message_ids"]),
      );
    });
  }

  /// Notify backend that sender is writing
  void typing({required String chatId, required bool isTyping}) {
    _socket.emit("typing", [
      {
        "chat_id": chatId,
        "is_typing": isTyping,
      }
    ]);
  }

  void createChat({required String requestUuid, required String recipient}) {
    _socket.emit("create-chat", [
      {
        "request_uuid": requestUuid,
        "user_id": recipient,
      }
    ]);
  }

  void createMessage({required String requestUuid, required String chatId, required String text}) {
    _socket.emit("create-message", [
      {
        "request_uuid": requestUuid,
        "chat_id": chatId,
        "text": text,
      }
    ]);
  }

  void readMessages({required String chatId, required List<String> messageIds}) {
    _socket.emit("read-messages", [
      {
        "chat_id": chatId,
        "message_ids": messageIds,
      }
    ]);
  }

  void onCreateMessageResponse({
    required void Function(String requestUuid, MessageModel message, String chatId) onSuccess,
    required void Function(String requestUuid, ApiException exception) onFailed,
  }) {
    _socket.on("create-message-response", (data) {
      String requestUuid = data["request_uuid"];
      bool success = data["success"];

      if (success) {
        onSuccess(
          requestUuid,
          MessageModel.fromJson(data["data"]),
          data["data"]["chat_id"],
        );
      } else {
        onFailed(
          requestUuid,
          ApiException.fromWs(data["data"]),
        );
      }
    });
  }

  void onCreateChatResponse({
    required void Function(String requestUuid, ChatModel chat) onSuccess,
    required void Function(String requestUuid, ApiException exception) onFailed,
  }) {
    _socket.on("create-chat-response", (data) {
      String requestUuid = data["request_uuid"];
      bool success = data["success"];

      if (success) {
        onSuccess(
          requestUuid,
          ChatModel.fromJson(data["data"]),
        );
      } else {
        onFailed(
          requestUuid,
          ApiException.fromWs(
            data["data"],
          ),
        );
      }
    });
  }

  void connect() {
    _socket.connect();
  }

  void onConnect(dynamic Function(dynamic) handler) {
    _socket.onConnect((data) => handler(data));
  }

  void dispose() {
    _socket.dispose();
  }
}
