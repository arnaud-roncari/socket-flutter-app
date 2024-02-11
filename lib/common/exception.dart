import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:socket_flutter_app/common/decoration.dart';

class ApiException {
  final String error;
  ApiException({required this.error});

  /// Extract the error from the response and throw an [ApiException].
  static fromHttp(Response response) {
    Map<String, dynamic> body = jsonDecode(response.body);

    String? message = body["message"];
    return ApiException(error: message ?? "Oups... Quelque chose vient de se casser.");
  }

  static fromWs(Map<String, dynamic> body) {
    String? message = body["message"];
    return ApiException(error: message ?? "Oups... Quelque chose vient de se casser.");
  }
}

/// Display an error message to screen.
void showSnackBarError({required BuildContext context, required Object exception}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        exception is ApiException ? exception.error : '$exception',
        style: kRegular18.copyWith(
          color: Colors.white,
        ),
      ),
    ),
  );
}
