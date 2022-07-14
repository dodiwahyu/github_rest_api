import 'package:github_app/api/identifiers.dart';
import 'package:github_app/core/networking/api.dart';
import 'package:github_app/core/networking/http_client.dart';

class RepoServices implements API {
  @override
  HTTPClient httpClient = HTTPClientImpl(ApiGitHubIdentifier());
}