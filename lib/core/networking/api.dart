import 'package:github_app/core/networking/http_client.dart';

abstract class API {
  API(this.httpClient);
  HTTPClient httpClient;
}