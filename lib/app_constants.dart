import 'package:flutter_dotenv/flutter_dotenv.dart';

String get gitHubClintId => dotenv.env['GITHUB_CLIENT'] ?? '';
String get gitHubSecretId => dotenv.env['GITHUB_SECRET'] ?? '';
String get gitHubRedirectUri => 'https://www.dodi.dev';