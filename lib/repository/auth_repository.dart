import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_flutter_app/common/constants.dart';
import 'package:socket_flutter_app/common/exception.dart';

class AuthRepository {
  Future<String> login({
    required String username,
    required String password,
  }) async {
    Response response = await post(
      Uri.parse('$kHttpUrl/auth/login'),
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "username": username,
          "password": password,
        },
      ),
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ApiException.fromHttp(response);
    }
    return jsonDecode(response.body)["accessToken"];
  }

  Future<String> signup({
    required String username,
    required String password,
  }) async {
    Response response = await post(
      Uri.parse('$kHttpUrl/auth/signup'),
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode(
        {
          "username": username,
          "password": password,
        },
      ),
    );

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ApiException.fromHttp(response);
    }
    return jsonDecode(response.body)["accessToken"];
  }
}
