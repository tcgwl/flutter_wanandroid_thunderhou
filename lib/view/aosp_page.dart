import 'package:flutter/material.dart';

/// '项目'页面
class AOSPPage extends StatefulWidget {
  @override
  _AOSPPageState createState() => _AOSPPageState();
}

class _AOSPPageState extends State<AOSPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('项目'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('项目'),
        )
    );
  }
}