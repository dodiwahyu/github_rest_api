import 'dart:io';
import 'dart:ui' as ui show PlaceholderAlignment;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_app/api/models/git_repo_model.dart';

class RepoListView extends StatelessWidget {
  const RepoListView(
      {Key? key, required this.listRepo, required this.isLoading})
      : super(key: key);

  final List<GitRepoModel> listRepo;
  final bool isLoading;

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
      if (listRepo.isNotEmpty) {
        return SliverPadding(
          padding:
              const EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final repo = listRepo[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.white54,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 6.0,
                  shadowColor: Colors.white54,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Image.asset(
                                'assets/images/icons/icon_repository.png',
                                color: Colors.white70,
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                maxLines: 5,
                                text: TextSpan(
                                  text: '${repo.fullName ?? '-'}  ',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      alignment: ui.PlaceholderAlignment.bottom,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white70),
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 1.0),
                                          child: Text(
                                            repo.private == true
                                                ? 'Private'
                                                : 'Public',
                                            style: const TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white70,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              repo.description ?? repo.fullName ?? '-',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            spacing: 16,
                            runSpacing: 6,
                            children: [
                              if (repo.language != null)
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3),
                                        child: Container(
                                          width: 13.0,
                                          height: 13.0,
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        repo.language ?? '-',
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              if (repo.stargazersCount != null)
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: SvgPicture.asset(
                                            'assets/images/icons/icon_star.svg',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        repo.getStarCount(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              if (repo.forksCount != null)
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: SvgPicture.asset(
                                            'assets/images/icons/icon_fork.svg',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        repo.getFork(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              if (repo.license != null)
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: SvgPicture.asset(
                                            'assets/images/icons/icon_license.svg',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        repo.license?.name ?? '-',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: listRepo.length,
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
