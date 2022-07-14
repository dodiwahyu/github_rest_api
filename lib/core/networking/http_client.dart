import 'dart:convert';
import 'dart:io';

import 'package:github_app/core/networking/http_exception.dart';
import 'package:github_app/core/networking/http_identifier.dart';
import 'package:github_app/core/networking/http_request.dart';
import 'package:http/http.dart';

typedef ResponseBuilderCallBack<T> = T Function(dynamic json);

abstract class HTTPClient {
  HTTPIdentifier get httpIdentifier;
  Future<T> send<T>(HTTPRequest request, ResponseBuilderCallBack builderCallBack);
}

class HTTPClientImpl implements HTTPClient {
  HTTPClientImpl(this.httpIdentifier);
  final Client client = Client();

  @override
  HTTPIdentifier httpIdentifier;

  @override
  Future<T> send<T>(HTTPRequest request, ResponseBuilderCallBack builderCallBack) async {
    try {
      Response response = await request.send(client, httpIdentifier);
      var decodeResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return builderCallBack(decodeResponse);
      } else {
        final message = decodeResponse['message'];
        final statusCode = response.statusCode;
        throw AppHttpException(message, statusCode: statusCode);
      }
    } on HttpException {
      throw AppHttpException('Check your connection', statusCode: 0);
    }
  }
}