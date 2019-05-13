import 'package:flutter/material.dart';

/// '公众号'页面
class WechatArticlePage extends StatefulWidget {
  @override
  _WechatArticlePageState createState() => _WechatArticlePageState();
}

class _WechatArticlePageState extends State<WechatArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公众号'),
        centerTitle: true,//设置标题居中
      ),
      body: Center(
        child: Text('公众号'),
      )
    );
  }
}