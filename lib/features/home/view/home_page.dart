import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/home/home_coordinator.dart';
import 'package:github_app/features/home/usecase/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends ViewStateless {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(
      builder: (context, viewModel, _) {
        return FutureBuilder(
            future: viewModel.getAuthenticatedUser(),
            builder:
                (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Scaffold(
                  body: _loading(),
                );
              } else {
                return Scaffold(
                  key: _key,
                  appBar: _appBar(context: context, userModel: snapshot.data),
                  body: FutureBuilder(
                    future: viewModel.getUsers(),
                    builder:
                        (context, AsyncSnapshot<List<UserModel>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        if (Platform.isIOS) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      } else {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('User not found!'),
                          );
                        } else {
                          final List<UserModel> users = snapshot.data ?? [];
                          return _listView(viewModel: viewModel, users: users);
                        }
                      }
                    },
                  ),
                  drawer: _createDrawer(context: context, homeVM: viewModel),
                );
              }
            });
      },
    );
  }

  Widget _loading() {
    if (Platform.isIOS) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  AppBar _appBar(
      {required BuildContext context, required UserModel? userModel}) {
    return AppBar(
      title: Text(userModel?.name ?? userModel?.login ?? 'Anonymous'),
      leading: Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: GestureDetector(
          child: CircleAvatar(
            backgroundImage: NetworkImage(userModel?.avatarUrl ?? ''),
          ),
          onTap: () => _key.currentState?.openDrawer(),
        ),
      ),
    );
  }

  ListView _listView(
      {required HomeVM viewModel, required List<UserModel> users}) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(20),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        final UserModel userModel = users[index];
        return FutureBuilder(
            future: viewModel.getUser(userModel.login ?? ''),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final user = snapshot.data ?? userModel;
                return _card(userModel: user);
              } else {
                return _card(userModel: userModel);
              }
            });
      },
    );
  }

  Widget _card({required UserModel userModel}) {
    return Card(
      margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 16.0,
      shadowColor: Colors.grey.shade50,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
        style: ListTileStyle.drawer,
        title: Text(
          userModel.name ?? 'Anonymous',
          style: const TextStyle(fontSize: 18.0, color: Colors.lightBlueAccent),
        ),
        subtitle: Text(userModel.login ?? '-'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userModel.avatarUrl ?? ''),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _createDrawer(
      {required BuildContext context, required HomeVM homeVM}) {
    final List<Map<String, String>> items = [
      {'name': 'Organization', 'icon': 'assets/images/icons/icon_org.png'},
      {'name': 'Followers', 'icon': 'assets/images/icons/icon_followers.png'},
      {'name': 'Following', 'icon': 'assets/images/icons/icon_following.png'},
      {'name': 'Starred', 'icon': 'assets/images/icons/icon_star.png'},
      {'name': 'Subscriptions', 'icon': 'assets/images/icons/icon_renew.png'},
      {'name': 'Repos', 'icon': 'assets/images/icons/icon_repository.png'},
      {'name': 'Logout', 'icon': 'assets/images/icons/icon_logout.png'}
    ];

    return Drawer(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return SizedBox(
                height: 270,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(homeVM.userModel?.avatarUrl ?? ''),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            homeVM.userModel?.name ?? 'Anonymous',
                            style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            homeVM.userModel?.login ?? '-',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              final title = items[index - 1]['name'] ?? '';
              final icon = items[index - 1]['icon'] ?? '';
              return ListTile(
                title: Text(title),
                leading: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image(image: AssetImage(icon)),
                ),
                onTap: () {
                  switch (title.toLowerCase()) {
                    case 'organization':
                      break;
                    case 'followers':
                      break;
                    case 'following':
                      break;
                    case 'starred':
                      break;
                    case 'subscriptions':
                      break;
                    case 'repos':
                      break;
                    case 'logout':
                      homeVM.logout().then((_) {
                        Navigator.pop(context);
                        navigateToLogin(context: context);
                      });
                      break;
                    default:
                      break;
                  }
                },
              );
            }
          }),
    );
  }
}
