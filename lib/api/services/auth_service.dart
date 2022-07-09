import 'package:github_app/core/networking/api.dart';
import 'package:github_app/api/identifiers.dart';
import 'package:github_app/api/models/auth_model.dart';
import 'package:github_app/core/networking/http_client.dart';
import 'package:github_app/core/networking/http_method.dart';
import 'package:github_app/core/networking/http_request.dart';
import 'package:github_app/features/auth/models/auth_req_model.dart';

class AuthServices implements API {
  @override
  HTTPClient httpClient = HTTPClientImpl(GitHubIdentifier());

  String get oauthURL =>
      '${httpClient.httpIdentifier.baseURL}/login/oauth/authorize';

  Future<AuthModel> getToken(
      AuthRequestModel requestModel, ResponseBuilderCallBack builderCallBack) {
    HTTPRequest req =
        HTTPRequest(path: '/login/oauth/access_token', method: HTTPMethod.post);
    req.parameters = requestModel.toJson();
    return httpClient.send(req, builderCallBack);
  }
}
