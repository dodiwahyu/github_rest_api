import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/auth/auth_factory.dart';
import 'package:github_app/features/auth/view/login_page.dart';
import 'package:github_app/features/auth/usecase/login_view_model.dart';
import 'package:github_app/features/auth/usecase/login_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with ModuleFactory {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => makeAuthVM()),
      ],
      child: MaterialApp(
        title: 'GitHub App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
