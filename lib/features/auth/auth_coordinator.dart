import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/coordinator.dart';
import 'package:github_app/features/auth/view/login_page.dart';
import 'package:github_app/features/home/view/home_page.dart';

extension AuthCoordinator on LoginPage {
  void navigateToHome({required BuildContext context}) {
    makeRoute(
        context: context,
        navigationModal: false,
        createPage: () => HomePage()).then((route) {
      Navigator.of(context).pushReplacement(route);
    });
  }
}
