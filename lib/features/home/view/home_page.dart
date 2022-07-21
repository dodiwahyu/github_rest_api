import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/home/home_coordinator.dart';
import 'package:github_app/features/home/usecase/home_view_model.dart';
import 'package:github_app/features/home/view/home_drawer.dart';
import 'package:github_app/features/home/view/user_list_view_item.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
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
                  drawer: HomeDrawer(
                    context: context,
                    homeVM: viewModel,
                    callBack: (selectedItem) {
                      final userModel = viewModel.userModel;
                      switch (selectedItem) {
                        case 'organization':
                          if (userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: userModel,
                                pageType: UserPageType.organization);
                          }
                          break;
                        case 'followers':
                          if (userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: userModel,
                                pageType: UserPageType.followers);
                          }
                          break;
                        case 'following':
                          if (userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: userModel,
                                pageType: UserPageType.following);
                          }
                          break;
                        case 'starred':
                          if (userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: userModel,
                                pageType: UserPageType.starred);
                          }
                          break;
                        case 'subscriptions':
                          if (userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: userModel,
                                pageType: UserPageType.subscriptions);
                          }
                          break;
                        case 'repos':
                          if (viewModel.userModel != null) {
                            navigateToUserDetail(
                                context: context,
                                userModel: viewModel.userModel!,
                                pageType: UserPageType.repos);
                          }
                          break;
                        case 'logout':
                          viewModel.logout().then(
                            (_) {
                              Navigator.pop(context);
                              navigateToLogin(context: context);
                            },
                          );
                          break;
                        default:
                          break;
                      }
                    },
                  ),
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
              UserListViewItem card;
              if (snapshot.connectionState == ConnectionState.done) {
                final user = snapshot.data ?? userModel;
                card = UserListViewItem(userModel: user);
              } else {
                card = UserListViewItem(userModel: userModel);
              }

              return GestureDetector(
                child: card,
                onTap: () {
                  final selectedModel = card.userModel;
                  navigateToUserDetail(
                      context: context,
                      userModel: selectedModel,
                      pageType: UserPageType.organization);
                },
              );
            });
      },
    );
  }
}
