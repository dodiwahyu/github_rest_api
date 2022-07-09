import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/coordinator.dart';

abstract class ViewStateful<T> extends StatefulWidget {
  const ViewStateful({Key? key}) : super(key: key);

  T get viewModel;
}

abstract class ViewStateless extends StatelessWidget {
  const ViewStateless({Key? key}) : super(key: key);

}