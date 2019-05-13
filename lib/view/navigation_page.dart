import 'package:flutter/material.dart';

/// '导航'页面
class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('导航'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('导航'),
        )
    );
  }
}