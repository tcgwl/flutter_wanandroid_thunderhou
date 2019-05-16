import 'package:flutter/material.dart';

/// 'TODO'页面
class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TODO'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('TODO'),
        )
    );
  }
}