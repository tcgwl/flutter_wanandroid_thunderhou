import 'package:flutter/material.dart';

/// '收藏'页面
class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('收藏'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('收藏'),
        )
    );
  }
}