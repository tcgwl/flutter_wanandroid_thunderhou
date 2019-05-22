import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final bool fav; //是否收藏

  ArticlePage(this.id, this.title, this.url, {this.fav}); //是否收藏

  @override
  State<StatefulWidget> createState() => ArticleState();
}

class ArticleState extends State<ArticlePage> {
  bool _fav;

  @override
  void initState() {
    super.initState();
    _fav = widget.fav;
  }

  @override
  Widget build(BuildContext context) {
    print('url:${widget.url}');

    AppBar _appbar;
    if (_fav == null) {
      _appbar = AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          _buildOpenWithBrowser(),
        ],
      );
    } else {
      _appbar = AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          _buildFavorite(),
          _buildOpenWithBrowser(),
//          _buildShare(),
        ],
      );
    }

    return WebviewScaffold(
      url: widget.url,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      withJavascript: true,
      appBar: _appbar,
      initialChild: Center(
        child: Loading(),
      ),
    );
  }

  _buildFavorite() {
    return IconButton(
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
    );
  }

  _buildOpenWithBrowser() {
    return IconButton(
      icon: Icon(Icons.open_in_new),
      onPressed: () {
        launch(widget.url);
      }
    );
  }

  _buildShare() {
    return IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          CommonUtil.share(widget.url);
        }
    );
  }

  _favorite() {
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