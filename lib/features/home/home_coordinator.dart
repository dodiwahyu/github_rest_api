import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/coordinator.dart';
import 'package:github_app/features/auth/view/login_page.dart';
import 'package:github_app/features/home/view/home_page.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
import 'package:github_app/features/user/view/user_page.dart';

extension HomeCoordinator on HomePage {
  void navigateToLogin({required BuildContext context}) {
    makeRoute(
        context: context,
        navigationModal: false,
        createPage: () => LoginPage()).then((route) {
      Navigator.of(context).pushReplacement(route);
    });
  }

  void navigateToUserDetail(
      {required BuildContext context,
      required UserModel userModel,
      required UserPageType pageType}) {
    makeRoute(
            context: context,
            createPage: () =>
                UserPage(userModel: userModel, initPageType: pageType))
        .then((route) {
      Navigator.of(context).push(route);
    });
  }
}
