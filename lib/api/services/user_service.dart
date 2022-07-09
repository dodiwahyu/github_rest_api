
import 'package:github_app/core/networking/api.dart';
import 'package:github_app/api/identifiers.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/networking/http_client.dart';
import 'package:github_app/core/networking/http_method.dart';
import 'package:github_app/core/networking/http_request.dart';

class UserServices implements API {
  @override
  HTTPClient httpClient = HTTPClientImpl(GitHubIdentifier());

  Future<UserModel> getAuthenticatedUser(ResponseBuilderCallBack builderCallBack) {
    HTTPRequest req = HTTPRequest(path: '/user', method: HTTPMethod.get);
    return httpClient.send(req, builderCallBack);
  }
}