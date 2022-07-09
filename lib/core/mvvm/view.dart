import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/coordinator.dart';

abstract class ViewStateful<T> extends StatefulWidget with Coordinator {
  const ViewStateful({Key? key}) : super(key: key);
  T get viewModel;
}

abstract class ViewStateless extends StatelessWidget with Coordinator {
  const ViewStateless({Key? key}) : super(key: key);
}