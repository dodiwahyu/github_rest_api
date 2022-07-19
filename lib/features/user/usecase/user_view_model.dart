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

  bool _loadingUpdateContent = false;
  bool get loadingUpdateContent => _loadingUpdateContent;

  UserPageType? _currentPageType;
  UserPageType get pageType {
    return _currentPageType ?? UserPageType.organization;
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  List<UserOrgModel> _listOrg = [];
  List<UserOrgModel> get listOrg => _listOrg;

  List<UserModel> _followers = [];
  List<UserModel> get followers => _followers;

  List<UserModel> _following = [];
  List<UserModel> get following => _following;

  void setUserPageType(UserPageType pageType, {bool needToRefresh = false}) {
    _currentPageType = pageType;
    switch (pageType) {
      case UserPageType.organization:
        getUserOrganization();
        break;

      case UserPageType.followers:
        getUserFollowers();
        break;

      case UserPageType.following:
        getUserFollowing();
        break;

      default:
        break;
    }

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

  // Get user organization
  void getUserOrganization() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _listOrg = await repository.userServices.getOrg(
          login: username, callBack: (response) {
        final list = response as List;
        return list.map((json) => UserOrgModel.fromJson(json)).toList();
      });

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e)  {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

  void getUserFollowers() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _followers = await repository.userServices.getFollowers(login: username, callBack: (response){
        final list = response as List;
        return list.map((e) => UserModel.fromJson(e)).toList();
      });

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

  void getUserFollowing() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _following = await repository.userServices.getFollowing(login: username, callBack: (response){
        final list = response as List;
        return list.map((e) => UserModel.fromJson(e)).toList();
      });

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

}
