import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/home/usecase/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends ViewStateless {
  const HomePage({Key? key}) : super(key: key);

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
                  appBar: _appBar(userModel: snapshot.data),
                  body: FutureBuilder(
                    future: viewModel.getUsers(),
                    builder:
                        (context, AsyncSnapshot<List<UserModel>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        if (Platform.isIOS) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              radius: 24,
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
                );
              }
            });
      },
    );
  }

  Widget _loading() {
    if (Platform.isIOS) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  AppBar _appBar({required UserModel? userModel}) {
    return AppBar(
      title: Text(userModel?.name ?? userModel?.login ?? 'Anonymous'),
      leading: Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(userModel?.avatarUrl ?? ''),
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
}