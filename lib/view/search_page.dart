import 'package:flutter/material.dart';

/// '搜索'页面
class SearchPage extends StatefulWidget {
  // 0:文章
  static const Search_Type_Article = 0;
  // 1:公众号
  static const Search_Type_WeChat = 1;
  final int type;
  final int sId;

  SearchPage(this.type, {Key key, this.sId}): super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('搜索'),
          centerTitle: true,//设置标题居中
        ),
        body: Center(
          child: Text('搜索'),
        )
    );
  }
}