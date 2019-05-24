import 'package:flutter/material.dart';
import 'package:wanandroid/view/favorite_list_page.dart';

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
        title: Text('我的收藏'),
      ),
      body: FavoriteListPage(),
    );
  }
}