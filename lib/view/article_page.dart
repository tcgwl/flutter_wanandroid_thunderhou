import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/common_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/loading.dart';

///文章页面
class ArticlePage extends StatefulWidget {
  final int id;
  final String title;
  final String url;
  final bool fav;

  ArticlePage(this.id, this.title, this.url, {this.fav}); //是否收藏

  @override
  State<StatefulWidget> createState() => ArticleState();
}

class ArticleState extends State<ArticlePage> {
  bool _fav = false;

  @override
  void initState() {
    super.initState();
    _fav = widget.fav;
  }

  Widget _buildAppBar() {
    AppBar _appbar;
    if (_fav) {
      _appbar = AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Constant.isLogin && _fav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              if (Constant.isLogin) {
                _favorite();
              } else {
                ToastUtil.showShort('请先登录');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              CommonUtil.share(widget.url);
            }
          )
        ],
      );
    } else {
      _appbar = AppBar(title: Text(widget.title));
    }
    return _appbar;
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: _buildAppBar(),
      url: widget.url,
      withZoom: false,
      withJavascript: true
    );
  }

  void _favorite() {
    if (_fav) {
      _cancelFavorite();
    } else {
      _doFavorite();
    }
  }

  Future<Null> _doFavorite() async {
    WanRequest().favorite(widget.id).then((res) {
      setState(() {
        _fav = true;
        bus.fire(FavoriteEvent());
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }

  Future<Null> _cancelFavorite() async {
    WanRequest().favoriteCancel(widget.id).then((res) {
      setState(() {
        _fav = false;
        bus.fire(FavoriteEvent());
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }
}