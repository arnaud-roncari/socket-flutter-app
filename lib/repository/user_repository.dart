import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class UserRepository {
  Future<UserModel> getUser() async {
    Response response = await get(
      Uri.parse('$kHttpUrl/user'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ApiException.fromHttp(response);
    }
    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<List<UserModel>> getAllUsers() async {
    Response response = await get(
      Uri.parse('$kHttpUrl/user/all'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ApiException.fromHttp(response);
    }
    return UserModel.fromJsons(jsonDecode(response.body));
  }

  Future<List<ChatModel>> getChats() async {
    Response response = await get(
      Uri.parse('$kHttpUrl/user/chat/all'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ApiException.fromHttp(response);
    }

    return ChatModel.fromJsons(jsonDecode(response.body));
  }

  Future<ChatModel> createChat({required UserModel recipient}) async {
    Response response = await post(
      Uri.parse('$kHttpUrl/user/chat/create'),
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
      throw ApiException.fromHttp(response);
    }

    return ChatModel.fromJson(jsonDecode(response.body));
  }
}
