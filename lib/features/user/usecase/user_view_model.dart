import 'package:github_app/core/mvvm/view_model.dart';
import 'package:github_app/features/user/usecase/user_repository.dart';

enum UserPageType {
  overView,
  organization,
  followers,
  following,
  starred,
  repos
}

class UserVM extends ViewModel<UserRepository> {
  UserVM({required super.repository});

  UserPageType? _pageType;
  UserPageType? get pageType => _pageType;
  void setUserPageType(UserPageType pageType) {
    _pageType = pageType;
    notifyListeners();
  }


}