import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:github_app/api/models/user_model.dart';
import 'package:github_app/core/mvvm/view.dart';
import 'package:github_app/features/user/usecase/user_view_model.dart';
import 'package:github_app/features/user/view/user_org.dart';
import 'package:provider/provider.dart';

import '../../../api/models/user_org_model.dart';

class UserPage extends ViewStateful {
  const UserPage(
      {Key? key, required this.userModel, required this.initPageType})
      : super(key: key);
  final UserModel userModel;
  final UserPageType initPageType;

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel? get userModel => widget.userModel;

  UserPageType get userPageType => widget.initPageType;

  final globalOffsetValue = ValueNotifier<double>(0);

  final valueScroll = ValueNotifier<double>(0);

  final ScrollController scrollControllerGlobally =
  ScrollController(initialScrollOffset: 50);

  @override
  void initState() {
    super.initState();
    scrollControllerGlobally.addListener(_listenToScrollChange);

    // Get organizations
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final vm = Provider.of<UserVM>(context, listen: false);
      vm.setUserModel(userModel);
      vm.getUserOrganization();
    });
  }

  @override
  void dispose() {
    scrollControllerGlobally.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _listenToScrollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Scrollbar(
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
                        userModel: userModel,
                        valueScroll: valueCurrentScroll,
                      ),
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: _MenuHeader(userModel: userModel)),
                      _buildContent(),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<UserVM>(builder: (BuildContext context, UserVM vm, _) {
      switch (vm.pageType) {
        case UserPageType.organization:
          return UserOrgView(vm: vm);
        default:
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
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
    });
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader({Key? key,
    required this.userModel,
    required this.valueScroll})
      : super(key: key);

  final UserModel? userModel;
  final double valueScroll;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = userModel?.avatarUrl ?? '';
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
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

const _maxHeaderExtent = 142.0;

class _MenuHeader extends SliverPersistentHeaderDelegate {
  _MenuHeader({this.userModel});

  final UserModel? userModel;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 8),
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
                  const _UserMenu()
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
    return true;
  }
}

class UserMenuItem {
  const UserMenuItem({required this.pageType,
    required this.title,
    required this.icon,
    this.badge,
    required this.isActive});

  final UserPageType pageType;
  final String title;
  final String icon;
  final int? badge;
  final bool isActive;
}

class _UserMenu extends StatelessWidget {
  const _UserMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserVM>(
      builder: (BuildContext context, UserVM viewModel, _) {
        final items = _getItems(viewModel);
        return Padding(
          padding:
          const EdgeInsets.only(left: 16, top: 12, bottom: 0, right: 16),
          child: SizedBox(
              height: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildMenuItem(items[0], viewModel),
                      _buildMenuItem(items[1], viewModel),
                      _buildMenuItem(items[2], viewModel)
                    ],
                  ),
                  Row(
                    children: [
                      _buildMenuItem(items[3], viewModel),
                      _buildMenuItem(items[4], viewModel),
                      _buildMenuItem(items[5], viewModel)
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  List<UserMenuItem> _getItems(UserVM vm) {
    final currentPage = vm.pageType;
    return [
      UserMenuItem(
          pageType: UserPageType.organization,
          title: "Organization",
          icon: 'assets/images/icons/icon_org.png',
          badge: null,
          isActive: currentPage == UserPageType.organization),
      UserMenuItem(
          pageType: UserPageType.followers,
          title: "Followers",
          icon: 'assets/images/icons/icon_followers.png',
          badge: 20,
          isActive: currentPage == UserPageType.followers),
      UserMenuItem(
          pageType: UserPageType.following,
          title: "Following",
          icon: 'assets/images/icons/icon_following.png',
          isActive: currentPage == UserPageType.following),
      UserMenuItem(
          pageType: UserPageType.starred,
          title: "Starred",
          icon: 'assets/images/icons/icon_star.png',
          isActive: currentPage == UserPageType.starred),
      UserMenuItem(
          pageType: UserPageType.subscriptions,
          title: "Subscriptions",
          icon: 'assets/images/icons/icon_renew.png',
          isActive: currentPage == UserPageType.subscriptions),
      UserMenuItem(
          pageType: UserPageType.repos,
          title: "Repos",
          icon: 'assets/images/icons/icon_repository.png',
          isActive: currentPage == UserPageType.repos),
    ];
  }

  void _didSelectedMenuItem(UserMenuItem menuItem, UserVM vm) {
    if (vm.pageType != menuItem.pageType) {
      vm.setUserPageType(menuItem.pageType, needToRefresh: true);
    }
  }

  Widget _buildMenuItem(UserMenuItem item, UserVM vm) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _didSelectedMenuItem(item, vm);
        },
        child: SizedBox(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    item.icon,
                    color: item.isActive ? Colors.white : Colors.white70,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    item.title,
                    style: TextStyle(
                        fontSize: item.isActive ? 13.0 : 12.0,
                        fontWeight:
                        item.isActive ? FontWeight.bold : FontWeight.normal,
                        color: item.isActive ? Colors.white : Colors.white54,
                        decoration: item.isActive
                            ? TextDecoration.underline
                            : TextDecoration.none),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
