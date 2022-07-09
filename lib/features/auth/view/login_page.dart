import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_app/features/auth/view/auth_page.dart';
import 'package:github_app/features/auth/usecase/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  dispose() {
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginVM viewModel = context.watch<LoginVM>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(hintText: 'Enter username or email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username or email';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String username = _usernameController.text;
                        viewModel.setUserName(username);
                        Uri uri = viewModel.generateUrlLogin();
                        _showAuthPage(context, viewModel, uri.toString());
                      }
                    },
                    child: const Text('Login')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAuthPage(
      BuildContext context, LoginVM viewModel, String uri) async {
    final String? url = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AuthPage(url: uri), fullscreenDialog: true));
    if (url != null) {
      viewModel.redirectUriAuth(url);
    }
  }
}
