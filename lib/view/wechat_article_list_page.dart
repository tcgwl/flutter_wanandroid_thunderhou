import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/model/wechat_article_bean.dart';
import 'package:flutter_wanandroid_thunderhou/net/api_manager.dart';
import 'package:flutter_wanandroid_thunderhou/widget/item_wechat_article.dart';

/// 微信文章列表页
class WechatArticleListPage extends StatefulWidget {
  final int cid;

  WechatArticleListPage({@required this.cid});

  @override
  _WechatArticleListState createState() => _WechatArticleListState();
}

class _WechatArticleListState extends State<WechatArticleListPage> with AutomaticKeepAliveClientMixin {
  int index = 1;
  List<Article> articles = List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getArticleList(false);
    _scrollController.addListener(() {
      var maxScrollExtent = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScrollExtent == pixels) {
        index++;
        getArticleList(true);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, position) {
        return WechatArticleItem(articles[position]);
      },
      controller: _scrollController,
    );

    return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
  }

  Future<Null> _pullToRefresh() async {
    index = 1;
    await getArticleList(false);
    return null;
  }

  /// 获取微信文章列表
  void getArticleList(bool isLoadMore) async {
     await ApiManager().getWechatArticle(widget.cid, index)
        .then((response) {
      if (response != null) {
        var wechatArticleBean = WechatArticleBean.fromJson(response.data);
        setState(() {
          if (!isLoadMore) {
            articles.clear();
          }
          articles.addAll(wechatArticleBean.data.datas);
        });
      }
    });
  }
}