import 'package:flutter/material.dart';
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

  void redirectUriAuth(String url) {
    _loading = true;
    notifyListeners();

    Uri uri = Uri.parse(url);
    repository.requestToken(uri: uri).then((auth) {
      debugPrint(auth.accessToken);
      _loading = false;
      notifyListeners();

    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      _loading = false;
      notifyListeners();
    });
  }

  Uri generateUrlLogin() {
    var model = LoginRequestModel(login: _username ?? '');
    return Uri.parse(repository.getOAuthURLString())
        .replace(queryParameters: model.toJson());
  }
}
