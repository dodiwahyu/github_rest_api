import 'package:github_app/core/networking/http_identifier.dart';

class GitHubIdentifier implements HTTPIdentifier {
  @override
  String get baseURL => 'https://github.com';
}

class ApiGitHubIdentifier implements HTTPIdentifier {
  @override
  String get baseURL => 'https://api.github.com';
}