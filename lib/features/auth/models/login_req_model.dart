import 'package:uuid/uuid.dart';
import 'package:github_app/app_constants.dart';

class LoginRequestModel {
  LoginRequestModel({required this.login});
  String clientID = gitHubClintId;
  String redirectUri = gitHubRedirectUri;
  String scope = 'user';
  String state = const Uuid().v4();
  bool allowSignup = true;
  String login;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientID;
    data['redirect_uri'] = redirectUri;
    data['scope'] = scope;
    data['state'] = state;
    data['allow_signup'] = allowSignup.toString();
    data['login'] = login;
    return data;
  }
}