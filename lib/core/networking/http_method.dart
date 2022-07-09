enum HTTPMethod {
  get,
  post,
  put,
  delete
}

extension HTTPMethodExtension on HTTPMethod {
  String get value {
    switch (this) {
      case HTTPMethod.get:
        return 'GET';
      case HTTPMethod.post:
        return 'POST';
      case HTTPMethod.put:
        return 'PUT';
      case HTTPMethod.delete:
        return 'DELETE';
    }
  }
}