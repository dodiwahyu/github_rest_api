import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
import 'package:github_app/api/models/user_model.dart';


class UserListView extends StatelessWidget {
  const UserListView({Key? key, required this.users, required this.isLoading}) : super(key: key);

  final bool isLoading;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: SafeArea(
          child: Platform.isIOS
              ? const CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.white54,
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white54,
                  ),
                ),
        ),
      );
    } else {
      final screenSize = MediaQuery.of(context).size;
      if (users.isNotEmpty) {
        return SliverPadding(
          padding: const EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final user = users[index];
                return CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                );
              },
              childCount: users.length
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: screenSize.width / 3,
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 24.0,
                childAspectRatio: 1.0),
          ),
        );
      } else {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: SafeArea(
            top: false,
            child: Container(
              color: Colors.transparent,
              child: const Icon(
                Icons.sentiment_very_satisfied,
                size: 75,
                color: Colors.white54,
              ),
            ),
          ),
        );
      }
    }
  }
}
