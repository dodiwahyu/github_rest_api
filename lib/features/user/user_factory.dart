import 'package:github_app/api/services/organization_services.dart';
import 'package:github_app/api/services/repo_services.dart';
import 'package:github_app/api/services/user_service.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/user/usecase/user_repository.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';

extension UserFactory on ModuleFactory {
  UserVM makeUserVM() {
    final userServices = UserServices();
    final orgServices = OrganizationServices();
    final repoServices = RepoServices();
    final repository = UserRepository(userServices: userServices, orgServices: orgServices, repoServices: repoServices);
    return UserVM(repository: repository);
  }
}