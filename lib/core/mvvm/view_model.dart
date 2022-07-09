import 'package:flutter/material.dart';
import 'package:github_app/core/mvvm/repository.dart';

abstract class ViewModel<T extends Repository> extends ChangeNotifier {
  ViewModel({required this.repository});
  T repository;
}
