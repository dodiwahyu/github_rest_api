import 'package:github_app/api/services/user_service.dart';
import 'package:github_app/core/mvvm/repository.dart';

class HomeRepository implements Repository {
  HomeRepository({required this.userServices});
  final UserServices userServices;
}