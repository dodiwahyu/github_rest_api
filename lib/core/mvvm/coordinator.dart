import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:github_app/core/mvvm/view.dart';

extension Coordinator on ViewStateless {
  Future<Route<String>> makeRoute<T extends Widget> ({
    required BuildContext context,
    required T Function() createPage
  }) async {
    var page = await buildWidgetAsync(createPage);
    return CupertinoPageRoute(
        builder: (_) => page,
        fullscreenDialog: true
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

