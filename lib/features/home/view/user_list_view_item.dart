import 'package:flutter/material.dart';
import 'package:github_app/api/models/user_model.dart';

class UserListViewItem extends StatelessWidget {
  const UserListViewItem({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
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