import 'package:flutter/material.dart';
import 'package:github_app/features/auth/usecase/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key, required this.url})
      : super(key: key);
  final String url;
  static String hostCallBack = 'dodi.dev';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    late WebViewController webViewController;
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.title ?? 'Login'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          String url = request.url;
          String host = Uri.parse(url).host;
          if (host.contains(hostCallBack)) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context,url);
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (_) async {
          viewModel.title = await webViewController.getTitle() ?? 'GitHub';
        },
        onPageFinished: (page) async {
          viewModel.title = await webViewController.getTitle() ?? 'GitHub';
        },
      ),
    );
  }
}
