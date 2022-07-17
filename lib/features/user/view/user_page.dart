import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
import 'package:provider/provider.dart';

class UserPage extends ViewStateful {
  const UserPage(
      {Key? key, required this.userModel, required this.initPageType})
      : super(key: key);
  final UserModel userModel;
  final UserPageType? initPageType;

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel? get userModel => widget.userModel;

  UserPageType? get userPageType => widget.initPageType;

  final globalOffsetValue = ValueNotifier<double>(0);

  final valueScroll = ValueNotifier<double>(0);

  final ScrollController scrollControllerGlobally =
      ScrollController(initialScrollOffset: 50);

  @override
  void initState() {
    super.initState();
    scrollControllerGlobally.addListener(_listenToScrollChange);
  }

  @override
  void dispose() {
    scrollControllerGlobally.dispose();
    super.dispose();
  }

  void _listenToScrollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserVM>(builder: (BuildContext ctx, UserVM viewModel, _) {
      viewModel.setUserPageType(userPageType ?? UserPageType.overView);
      return Scaffold(
        body: Scrollbar(
          controller: scrollControllerGlobally,
          radius: const Radius.circular(8),
          scrollbarOrientation: ScrollbarOrientation.right,
          notificationPredicate: (scroll) {
            valueScroll.value = scroll.metrics.extentInside;
            return true;
          },
          child: ValueListenableBuilder(
              valueListenable: globalOffsetValue,
              builder: (_, double valueCurrentScroll, __) {
                return CustomScrollView(
                  controller: scrollControllerGlobally,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: <Widget>[
                    _FlexibleSpaceBarHeader(
                      vm: viewModel,
                      userModel: userModel,
                      valueScroll: valueCurrentScroll,
                    ),
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: _MenuHeader(userModel: userModel, userVM: viewModel)
                    ),
                    // _makeHeader(context: context),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 4.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.teal[100 * (index % 9)],
                            child: Text('Grid Item $index'),
                          );
                        },
                        childCount: 20,
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 50.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.lightBlue[100 * (index % 9)],
                            child: Text('List Item $index'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader(
      {Key? key,
      required this.vm,
      required this.userModel,
      required this.valueScroll})
      : super(key: key);

  final UserVM vm;
  final UserModel? userModel;
  final double valueScroll;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = userModel?.avatarUrl ?? '';
    final screenWidth = MediaQuery.of(context).size.width;
    final contentHeight = screenWidth * (9 / 12);
    return SliverAppBar(
      expandedHeight: contentHeight,
      stretch: true,
      pinned: valueScroll < 90 ? true : false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Image.network(avatarUrl),
            ),
          ],
        ),
      ),
    );
  }
}

const _maxHeaderExtent = 135.0;

class _MenuHeader extends SliverPersistentHeaderDelegate {
  _MenuHeader({this.userModel, required this.userVM});
  final UserModel? userModel;
  final UserVM userVM;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    final safeArea = MediaQuery.of(context).padding;
    var opacityValue = percent * 1;
    if (opacityValue < 0) {
      opacityValue = 0;
    } else if (opacityValue > 1) {
      opacityValue = 1;
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _maxHeaderExtent,
              color: Colors.blue,
              child: Column(
                children: [
                  AnimatedSize(
                      duration: const Duration(microseconds: 300),
                      child: SizedBox(
                        height: safeArea.top * percent,
                      )),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: [
                          AnimatedOpacity(
                              opacity: opacityValue,
                              duration: const Duration(microseconds: 300),
                              child: Icon(
                                Platform.isIOS
                                    ? Icons.arrow_back_ios
                                    : Icons.arrow_back,
                                color: Colors.white,
                              )),
                          AnimatedSlide(
                            duration: const Duration(microseconds: 300),
                            offset: Offset((percent * 0.18) - 0.1, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel?.name ?? 'Anonymous',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  userModel?.login ?? '-',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            )),

      ],
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
