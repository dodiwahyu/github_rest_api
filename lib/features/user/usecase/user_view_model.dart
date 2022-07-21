import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/api/models/user_org_model.dart';
import 'package:github_app/api/models/git_repo_model.dart';
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

  List<GitRepoModel> _listPinnedRepo = [];

  List<GitRepoModel> get listPinnedRepo => _listPinnedRepo;

  List<GitRepoModel> _subscriptions = [];
  List<GitRepoModel> get subscriptions => _subscriptions;

  List<GitRepoModel> _repos = [];
  List<GitRepoModel> get repos => _repos;

  void reset() {
    _currentPageType = null;
    _userModel = null;
    _listOrg = [];
    _following = [];
    _followers = [];
    _listPinnedRepo = [];
    _subscriptions = [];
    _repos = [];
  }

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

      case UserPageType.starred:
        getPinnedRepo();
        break;

      case UserPageType.subscriptions:
        getSubscriptionRepo();
        break;

      case UserPageType.repos:
        getRepos();
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
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

  // Get followers
  void getUserFollowers() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _followers = await repository.userServices.getFollowers(
          login: username, callBack: (response) {
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

  // Get following
  void getUserFollowing() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }

    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _following = await repository.userServices.getFollowing(
          login: username, callBack: (response) {
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

  // Get pinned repo
  void getPinnedRepo() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }
    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _listPinnedRepo = await repository.userServices.getPinnedRepo(
        login: username, callBack: (response) {
        final list = response as List;
        return list.map((e) => GitRepoModel.fromJson(e)).toList();
      },);

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

  void getSubscriptionRepo() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }
    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _subscriptions = await repository.userServices.getSubscriptions(
        login: username, callBack: (response) {
        final list = response as List;
        return list.map((e) => GitRepoModel.fromJson(e)).toList();
      },);

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

  void getRepos() async {
    final username = userModel?.login;
    if (username == null) {
      return;
    }
    _loadingUpdateContent = true;
    notifyListeners();

    try {
      _repos = await repository.userServices.getRepos(
        login: username, callBack: (response) {
        final list = response as List;
        return list.map((e) => GitRepoModel.fromJson(e)).toList();
      },);

      _loadingUpdateContent = false;
      notifyListeners();
    } catch (e) {
      print(e);

      _loadingUpdateContent = false;
      notifyListeners();
    }
  }

}
