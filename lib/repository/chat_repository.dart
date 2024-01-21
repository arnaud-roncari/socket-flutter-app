import 'dart:convert';

import 'package:http/http.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class ChatRepository {
  Future<List<ChatModel>> getChats() async {
    Response response = await get(
      Uri.parse('$kApiUrl/chat/all'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throwApiException(response);
    }

    return ChatModel.fromJsons(jsonDecode(response.body));
  }

  Future<ChatModel> createChat({required UserModel recipient}) async {
    Response response = await post(
      Uri.parse('$kApiUrl/chat/create'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "user_id": recipient.id,
        },
      ),
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throwApiException(response);
    }

    return ChatModel.fromJson(jsonDecode(response.body));
  }
}
