import 'package:flutter/material.dart';
import 'package:github_app/api/models/auth_model.dart';
import 'package:github_app/core/mvvm/view_model.dart';
import 'package:github_app/features/auth/models/login_req_model.dart';
import 'package:github_app/features/auth/usecase/login_repository.dart';

class LoginVM extends ViewModel<LoginRepository> {
  LoginVM({required super.repository});

  bool _loading = false;
  String? _username;

  bool get loading => _loading;

  void setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  void setUserName(String? username) {
    _username = username;
  }

  Future<void> redirectUriAuth(String url) async {
    _loading = true;
    notifyListeners();

    Uri uri = Uri.parse(url);
    return repository.requestToken(uri: uri).then((auth) {
      _loading = false;
      notifyListeners();
      return auth.saveToPreferences();
    });
  }

  Uri generateUrlLogin() {
    var model = LoginRequestModel(login: _username ?? '');
    return Uri.parse(repository.getOAuthURLString())
        .replace(queryParameters: model.toJson());
  }
}
