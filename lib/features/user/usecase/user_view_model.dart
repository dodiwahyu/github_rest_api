import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/api/models/user_org_model.dart';
import 'package:github_app/core/mvvm/view_model.dart';
import 'package:github_app/features/user/usecase/user_repository.dart';

enum UserPageType {
  organization,
  followers,
  following,
  starred,
  subscriptions,
  repos
}

class UserVM extends ViewModel<UserRepository> {
  UserVM({required super.repository});

  bool _loadingGetOrg = false;
  bool get loadingUpdateOrg => _loadingGetOrg;

  UserPageType? _currentPageType;
  UserPageType get pageType {
    return _currentPageType ?? UserPageType.organization;
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  List<UserOrgModel> _listOrg = [];
  List<UserOrgModel> get listOrg => _listOrg;

  void setUserPageType(UserPageType pageType, {bool needToRefresh = false}) {
    _currentPageType = pageType;
    if (needToRefresh) {
      notifyListeners();
    }
  }

  void setUserModel(UserModel? model, {bool needToRefresh = false}) {
    _userModel = model;
    if (needToRefresh) {
      notifyListeners();
    }
  }

  void getUserOrganization() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingGetOrg = true;
    notifyListeners();

    try {
      _listOrg = await repository.userServices.getOrg(
          login: username, callBack: (response) {
        final list = response as List;
        return list.map((json) => UserOrgModel.fromJson(json)).toList();
      });

      _loadingGetOrg = false;
      notifyListeners();
    } catch (e)  {
      print(e);

      _loadingGetOrg = false;
      notifyListeners();
    }
  }
}
