import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class Coordinator {}

extension CoordinatorImpl on Coordinator {
  Future<Route<String>> makeRoute<T extends Widget> ({
    required BuildContext context,
    bool navigationModal = true,
    required T Function() createPage
  }) async {
    var page = await buildWidgetAsync<T>(createPage);
    return CupertinoPageRoute(
        builder: (_) => page,
        fullscreenDialog: navigationModal == false
    );
  }
  
  void pop<T extends Object?>(BuildContext context, [T? results]) {
    return Navigator.of(context).pop(results);
  }

  Future<T> buildWidgetAsync<T extends Widget>(T Function() createPage) async {
    return Future.microtask(() {
      return createPage();
    });
  }
}
