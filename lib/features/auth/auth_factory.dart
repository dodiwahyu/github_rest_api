import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/auth/usecase/login_view_model.dart';
import 'package:github_app/features/auth/usecase/login_repository.dart';

extension AuthFactory on ModuleFactory {
  LoginVM makeAuthVM({BuildContext? context}) {
    LoginRepository repository = LoginRepository();
    return LoginVM(repository: repository);
  }
}