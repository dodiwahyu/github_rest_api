import 'package:flutter/foundation.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view_model.dart';
import 'package:github_app/features/home/usecase/home_repository.dart';

class HomeVM extends ViewModel<HomeRepository> {
  HomeVM({required super.repository});

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<UserModel?> getAuthenticatedUser() async {
    try {
      _userModel = await repository.userServices.getAuthenticatedUser(
          (json) => UserModel.fromJson(json as Map<String, dynamic>));
      return _userModel;
    } catch (error) {
      return _userModel;
    }
  }

  Future<List<UserModel>> getUsers() {
    return repository.userServices.getAllUsers((json) {
      final list = json as List;
      return list.map((e) => UserModel.fromJson(e)).toList();
    });
  }

  Future<UserModel> getUser(String login) async {
    return repository.userServices.getUser(
        login: login,
        callBack: (json) => UserModel.fromJson(json as Map<String, dynamic>));
  }

}
