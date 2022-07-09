import 'package:github_app/app_constants.dart';

class AuthRequestModel {
  AuthRequestModel({
    required this.code,
    required this.state
  });

  String clientID = gitHubClintId;
  String clientSecret = gitHubSecretId;
  String redirectUri = gitHubRedirectUri;
  String? state;
  String? code;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientID;
    data['client_secret'] = clientSecret;
    data['redirect_uri'] = redirectUri;
    data['state'] = state;
    data['code'] = code;
    return data;
  }

  AuthRequestModel.fromJson(Map<String, dynamic> json) {
    state = json['state'] ?? '';
    code = json['code'] ?? '';
  }
}