import 'package:flutter/material.dart';

/// '关于'页面
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('关于'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('关于'),
        )
    );
  }
}