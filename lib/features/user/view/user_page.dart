import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
import 'package:provider/provider.dart';

class UserPage extends ViewStateless {
  const UserPage(
      {Key? key, required this.userModel, required this.initPageType})
      : super(key: key);
  final UserModel userModel;
  final UserPageType? initPageType;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserVM>(builder: (BuildContext ctx, UserVM viewModel, _) {
      viewModel.setUserPageType(initPageType ?? UserPageType.overView);
      return Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            _header(context: context, vm: viewModel),
            _menu(context: context, vm: viewModel),
          ],
        ),
      );
    });
  }

  Widget _header({required BuildContext context, required UserVM vm}) {
    final avatarUrl = userModel.avatarUrl ?? '';
    final screenWidth = MediaQuery.of(context).size.width * (9 / 12);
    return SliverAppBar(
      pinned: true,
      expandedHeight: screenWidth,
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20),
          child: ListTile(
            title: Text(
              userModel.name ?? 'Anonymous',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userModel.login ?? '',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white54,
              ),
            ),
          ),
        ),
        background: FittedBox(
          fit: BoxFit.fitWidth,
          child: Image(image: NetworkImage(avatarUrl)),
        ),
      ),
    );
  }

  Widget _menu({required BuildContext context, required UserVM vm}) {
    return const SliverAppBar(
      title: Text('Test Menu'),
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(),
    );
  }
}
