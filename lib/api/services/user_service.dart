import 'package:github_app/api/models/git_repo_model.dart';
import 'package:github_app/api/services/services.dart';
import 'package:github_app/core/networking/api.dart';
import 'package:github_app/api/identifiers.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/api/models/user_org_model.dart';
import 'package:github_app/core/networking/http_client.dart';
import 'package:github_app/core/networking/http_method.dart';
import 'package:github_app/core/networking/http_request.dart';

class UserServices implements API {
  @override
  HTTPClient httpClient = HTTPClientImpl(ApiGitHubIdentifier());

  Future<UserModel> getAuthenticatedUser(
      ResponseBuilderCallBack builderCallBack) async {
    final HTTPRequest req = HTTPRequest(path: '/user', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, builderCallBack);
  }

  Future<List<UserModel>> getAllUsers(
      ResponseBuilderCallBack builderCallBack) async {
    final HTTPRequest req = HTTPRequest(path: '/users', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, builderCallBack);
  }

  Future<UserModel> getUser(
      {required String login,
      required ResponseBuilderCallBack callBack}) async {
    final HTTPRequest req =
        HTTPRequest(path: '/users/$login', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }

  Future<List<UserOrgModel>> getOrg(
      {required String login,
      required ResponseBuilderCallBack callBack}) async {
    final req = HTTPRequest(path: '/users/$login/orgs', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }

  Future<List<UserModel>> getFollowers(
      {required String login,
      required ResponseBuilderCallBack callBack}) async {
    final req =
        HTTPRequest(path: '/users/$login/followers', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }

  Future<List<UserModel>> getFollowing(
      {required String login,
        required ResponseBuilderCallBack callBack}) async {
    final req =
    HTTPRequest(path: '/users/$login/following', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }

  Future<List<GitRepoModel>> getPinnedRepo({required String login, required ResponseBuilderCallBack callBack}) async {
    final req = HTTPRequest(path: '/users/$login/starred', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }
  
  Future<List<GitRepoModel>> getSubscriptions({required String login, required ResponseBuilderCallBack callBack}) async {
    final req = HTTPRequest(path: '/users/$login/subscriptions', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }

  Future<List<GitRepoModel>> getRepos({required String login, required ResponseBuilderCallBack callBack}) async {
    final req = HTTPRequest(path: '/users/$login/repos', method: HTTPMethod.get);
    await req.setHeader(isAuthenticated: true);
    return httpClient.send(req, callBack);
  }
  
}
