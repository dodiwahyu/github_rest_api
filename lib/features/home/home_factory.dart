
import 'package:github_app/api/services/user_service.dart';
import 'package:github_app/core/mvvm/module_factory.dart';
import 'package:github_app/features/home/usecase/home_repository.dart';
import 'package:github_app/features/home/usecase/home_view_model.dart';

extension HomeFactory on ModuleFactory {
  HomeVM makeHomeVM() {
    final userServices = UserServices();
    final repository = HomeRepository(userServices: userServices);
    return HomeVM(repository: repository);
  }
}