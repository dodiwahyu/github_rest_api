import 'package:github_app/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel {
  String? accessToken;
  String? scope;
  String? tokenType;

  AuthModel({
    this.accessToken,
    this.scope,
    this.tokenType
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] ;
    scope = json['scope'];
    tokenType = json['token_type'];
  }

  Future<void> saveToPreferences() async {
    var pref = await SharedPreferences.getInstance();
    if (accessToken != null) {
      pref.setString(kPrefAccessToken, accessToken!);
    } else {
      pref.remove(kPrefAccessToken);
    }

    if (scope != null) {
      pref.setString(kPrefAccessScope, scope!);
    } else {
      pref.remove(kPrefAccessScope);
    }

    if (tokenType != null) {
      pref.setString(kPrefAccessTokenType, tokenType!);
    } else {
      pref.remove(kPrefAccessTokenType);
    }
  }

  static Future<AuthModel?> getAuthFromPreferences() async {
    var pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(kPrefAccessToken);
    var scope = pref.getString(kPrefAccessScope);
    var tokenType = pref.getString(kPrefAccessTokenType);

    return AuthModel(accessToken: accessToken, scope: scope, tokenType: tokenType);
  }

  static clearSessions() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(kPrefAccessTokenType);
    pref.remove(kPrefAccessToken);
    pref.remove(kPrefAccessScope);
  }
}