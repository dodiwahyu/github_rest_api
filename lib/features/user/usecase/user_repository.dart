import 'package:github_app/api/services/organization_services.dart';
import 'package:github_app/api/services/repo_services.dart';
import 'package:github_app/api/services/user_service.dart';
import 'package:github_app/core/mvvm/repository.dart';

class UserRepository extends Repository {
  UserRepository({required this.userServices, required this.orgServices, required this.repoServices});
  final UserServices userServices;
  final OrganizationServices orgServices;
  final RepoServices repoServices;
}