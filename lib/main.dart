import 'package:flutter/material.dart';
import 'package:github_app/api/models/auth_model.dart';
import 'package:github_app/app_constants.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/auth/auth_factory.dart';
import 'package:github_app/features/auth/view/login_page.dart';
import 'package:github_app/features/auth/usecase/login_view_model.dart';
import 'package:github_app/features/auth/usecase/login_repository.dart';
import 'package:github_app/features/home/home_factory.dart';
import 'package:github_app/features/home/view/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with ModuleFactory {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString(kPrefAccessToken);
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => makeAuthVM()),
        ChangeNotifierProvider(create: (_) => makeHomeVM()),
      ],
      child: MaterialApp(
        title: 'GitHub App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<bool>(
          future: _isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const Scaffold(
                body: Text('Splash screen'),
              );
            }

            final isLoggedIn = snapshot.data ?? false;

            if (isLoggedIn) {
              return HomePage();
            }

            return LoginPage();
          },
        ),
      ),
    );
  }
}
