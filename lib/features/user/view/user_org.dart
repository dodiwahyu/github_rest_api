import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_org_model.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';

class UserOrgView extends StatelessWidget {
  const UserOrgView({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final UserVM vm;

  @override
  Widget build(BuildContext context) {
    if (vm.loadingUpdateOrg) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: SafeArea(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator(
                radius: 20, color: Colors.white54)
                : const Center(child: CircularProgressIndicator(color: Colors.white54,)),)
      );
    } else {
      final listOrg = vm.listOrg;
      if (listOrg.isNotEmpty) {
        return SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blue[200 + index % 4 * 100],
                      height: 100 + index % 4 * 20.0,
                      child: Text('Item: $index'),
                    ),
                  );
                }, childCount: listOrg.length));
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
