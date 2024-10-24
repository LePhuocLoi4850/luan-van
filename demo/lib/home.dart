import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MessengerWebView extends StatefulWidget {
  const MessengerWebView({Key? key}) : super(key: key);

  @override
  State<MessengerWebView> createState() => _MessengerWebViewState();
}

class _MessengerWebViewState extends State<MessengerWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            // Show loading indicator.
          },
          onPageFinished: (String url) {
            // Hide loading indicator.
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error.
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle navigation request.
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.messenger.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messenger'), actions: [
        IconButton(
            onPressed: () {
              Get.to(OpenMessengerButton());
            },
            icon: Icon(Icons.chat))
      ]),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class OpenMessengerButton extends StatelessWidget {
  const OpenMessengerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final Uri url = Uri.parse('fb-messenger://user-thread/100065231167398');
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      },
      child: const Text('Mở Messenger'),
    );
  }
}
