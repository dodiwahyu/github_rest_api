import 'dart:convert';
import 'dart:io';

import 'package:github_app/core/networking/http_identifier.dart';
import 'package:github_app/core/networking/http_request.dart';
import 'package:http/http.dart';

typedef ResponseBuilderCallBack<T> = T Function(Map<String, dynamic> json);

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
      if (response.statusCode == 200) {
        var decodeResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return builderCallBack(decodeResponse);
      } else {
        throw Exception(['Response not success']);
      }
    } on HttpException {
      throw Exception(['Check your connection']);
    } on Exception {
      throw Exception(['Error response']);
    }
  }
}