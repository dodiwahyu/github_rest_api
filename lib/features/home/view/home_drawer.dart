
import 'package:flutter/material.dart';
import 'package:github_app/features/home/usecase/home_view_model.dart';

typedef HomeDrawerDidSelectItem = Function(String selectedItem);

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.context,
    required this.homeVM,
    required this.callBack,
  }) : super(key: key);

  final BuildContext context;
  final HomeVM homeVM;
  final HomeDrawerDidSelectItem callBack;

  @override
  Widget build(BuildContext context) {
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
          physics: const NeverScrollableScrollPhysics(),
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
                  callBack(title.toLowerCase());
                },
              );
            }
          }),
    );
  }
}