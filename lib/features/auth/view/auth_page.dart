import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.url})
      : super(key: key);
  final String url;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String title = 'GitHub';
  late WebViewController webViewController;
  final String hostCallBack = 'dodi.dev';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: widget.url,
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
          String pageTitle = await webViewController.getTitle() ?? 'GitHub';
          setState(() {
            title = pageTitle;
          });
        },
        onPageFinished: (_) async {
          String pageTitle = await webViewController.getTitle() ?? 'GitHub';
          setState(() {
            title = pageTitle;
          });
        },
      ),
    );
  }
}
