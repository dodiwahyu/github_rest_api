import 'dart:async';

import 'package:github_app/app_constants.dart';
import 'package:github_app/core/networking/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension HTTPRequestHeader on HTTPRequest {
  FutureOr setHeader(
      {bool isAuthenticated = false, Map<String, String>? json}) async {
    final allHeader = <String, String>{};
    if (isAuthenticated) {
      final pref = await SharedPreferences.getInstance();
      final tokenType = pref.get(kPrefAccessTokenType);
      final token = pref.getString(kPrefAccessToken);
      if (token != null && tokenType != null) {
        if (tokenType == 'bearer') {
          allHeader['Authorization'] = 'Bearer $token';
        } else {
          allHeader['Authorization'] = 'token $token';
        }
      }
    }
    headers = allHeader;
  }
}
