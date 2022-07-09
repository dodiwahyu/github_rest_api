class AuthModel {
  String? accessToken;
  String? scope;
  String? tokenType;

  AuthModel({
    this.accessToken,
    this.scope,
    this.tokenType
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] ;
    scope = json['scope'];
    tokenType = json['token_type'];
  }
}