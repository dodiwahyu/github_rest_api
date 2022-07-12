import 'package:github_app/core/networking/http_identifier.dart';
import 'package:github_app/core/networking/http_method.dart';
import 'package:http/http.dart';

class HTTPRequest {
  HTTPMethod method;
  Map<String, dynamic>? parameters;
  Map<String, String>? headers;
  String path;

  HTTPRequest({
    required this.path,
    required this.method,
    this.parameters,
    this.headers
  });
}

extension HTTPRequestImpl on HTTPRequest {
  Future<Response> send(Client client,HTTPIdentifier httpIdentifier) async {
    Uri url = Uri.parse('${httpIdentifier.baseURL}$path');
    Map<String,String> allHeaders = {'Accept': 'application/json'};

    // Set custom header
    headers?.forEach((key, value) {
      allHeaders[key] = value;
    });

    switch (method) {
      case HTTPMethod.get:
        if (parameters != null) {
          url.replace(queryParameters: parameters!);
        }
        return client.get(url, headers: allHeaders);

      case HTTPMethod.post:
        return client.post(url,headers: allHeaders, body: parameters ?? {});

      case HTTPMethod.put:
        return client.put(url, headers: allHeaders, body: parameters ?? {});

      case HTTPMethod.delete:
        return client.delete(url, headers: allHeaders, body: parameters ?? {});
    }
  }
}