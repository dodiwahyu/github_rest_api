import 'dart:io';

class AppHttpException extends HttpException {
  AppHttpException(super.message, {required this.statusCode, this.data});
  int statusCode = 0;
  Map<String, dynamic>? data;
}