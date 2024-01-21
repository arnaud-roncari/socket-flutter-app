import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class UserRepository {
  Future<UserModel> getUser() async {
    Response response = await get(
      Uri.parse('$kApiUrl/user'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throwApiException(response);
    }
    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<List<UserModel>> getAllUsers() async {
    Response response = await get(
      Uri.parse('$kApiUrl/user/all'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throwApiException(response);
    }
    return UserModel.fromJsons(jsonDecode(response.body));
  }
}
