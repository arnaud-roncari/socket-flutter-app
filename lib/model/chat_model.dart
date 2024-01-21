import 'package:socket_flutter_app/model/message_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class ChatModel {
  final List<UserModel> users;
  final List<MessageModel> messages;

  ChatModel({required this.users, required this.messages});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      users: UserModel.fromJsons(json["users"]),
      messages: MessageModel.fromJsons(json["messages"]),
    );
  }

  static List<ChatModel> fromJsons(List jsons) {
    List<ChatModel> chats = [];
    for (Map<String, dynamic> json in jsons) {
      chats.add(ChatModel.fromJson(json));
    }
    return chats;
  }
}
