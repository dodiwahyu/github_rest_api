import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';

class UserOrgView extends StatelessWidget {
  const UserOrgView({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final UserVM vm;

  @override
  Widget build(BuildContext context) {
    if (vm.loadingUpdateContent) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: SafeArea(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator(
                    radius: 20, color: Colors.white54)
                : const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white54,
                  )),
          ));
    } else {
      final listOrg = vm.listOrg;
      final screenSize = MediaQuery.of(context).size;
      if (listOrg.isNotEmpty) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (
                BuildContext context,
                int index,
              ) {
                final org = listOrg[index];
                return Container(
                  color: Colors.white,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image.network(
                        org.avatarUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              bottom: 6.0,
                              left: 6.0,
                              right: 6.0,
                              top: 16,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.blue],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Text(
                              org.login ?? '-',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: listOrg.length,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: screenSize.width / 3,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
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
