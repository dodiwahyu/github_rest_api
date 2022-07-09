import 'package:github_app/api/models/auth_model.dart';
import 'package:github_app/api/services/auth_service.dart';
import 'package:github_app/core/mvvm/repository.dart';
import 'package:github_app/features/auth/models/auth_req_model.dart';


class LoginRepository implements Repository {
  final AuthServices _authServices = AuthServices();

  String getOAuthURLString() {
    return _authServices.oauthURL;
  }

  Future<AuthModel> requestToken({required Uri uri}) async {
    Map<String, dynamic> json = uri.queryParameters;
    AuthRequestModel requestModel = AuthRequestModel.fromJson(json);
    return _authServices.getToken(requestModel, (json) => AuthModel.fromJson(json));
  }
}