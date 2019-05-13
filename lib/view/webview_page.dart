import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({this.title, @required this.url});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebviewScaffold(
        url: widget.url,
        withZoom: false,
        withLocalStorage: true,
        hidden: true,
        withJavascript: true,
      ),
    );
  }
}