import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:github_app/app_constants.dart';
import 'package:github_app/core/utils/functions.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/auth/auth_factory.dart';
import 'package:github_app/features/auth/view/login_page.dart';
import 'package:github_app/features/home/home_factory.dart';
import 'package:github_app/features/home/view/home_page.dart';
import 'package:github_app/features/user/user_factory.dart';
import 'package:github_app/firebase_options.dart';


Future main() async {

  // instrumenting the zone’s error handler will catch errors that aren't
  // caught by the Flutter framework
  // (for example, in a button’s onPressed handler):
  runZonedGuarded(() async {

    // Load file .env
    await dotenv.load(fileName: ".env");

    // Binding widget flutter
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Initialize FirebaseAnalytics
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logAppOpen();

    // Get permission
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      printLog('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      printLog('User granted provisional');
    } else {
      printLog('User declined or has not accepted permission');
    }

    // Get FCM Token
    final token = await FirebaseMessaging.instance.getToken();
    printLog('token => $token');

    runApp(const MyApp());

  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
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
        ChangeNotifierProvider(create: (_) => makeUserVM()),
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
