import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/model/wechat_count_bean.dart';
import 'package:flutter_wanandroid_thunderhou/net/api_manager.dart';
import 'package:flutter_wanandroid_thunderhou/view/wechat_article_list_page.dart';
import 'package:flutter_wanandroid_thunderhou/widget/async_snapshot_widget.dart';

/// '公众号'页面
class WechatArticlePage extends StatefulWidget {
  @override
  _WechatArticlePageState createState() => _WechatArticlePageState();
}

class _WechatArticlePageState extends State<WechatArticlePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _tabNames = List<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: _buildFuture, future: getWechatCount());
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot<List<WechatCount>> snapshot) {
    return AsyncSnapshotWidget(
      snapshot: snapshot,
      successWidget: (snapshot) {
        if (snapshot.data != null) {
          _parseWechatCounts(snapshot.data);

          if (_tabController == null) {
            _tabController = TabController(
                length: snapshot.data.length,
                vsync: this,
                initialIndex: 0
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('公众号'),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                TabBar(
                  tabs: _createTabs(),
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.black45,
                  controller: _tabController,
                  isScrollable: true,
                ),
                Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: _createPages(snapshot.data),
                    controller: _tabController,
                  )
                )
              ],
            ),
          );
        }
      },
    );
  }

  /// 解析微信公众号列表
  void _parseWechatCounts(List<WechatCount> weChatCounts) {
    _tabNames.clear();
    for (WechatCount count in weChatCounts) {
      _tabNames.add(count.name);
    }
  }

  /// 生成顶部tab
  List<Widget> _createTabs() {
    List<Widget> widgets = List();
    for (String name in _tabNames) {
      var tab = Tab(text: name);
      widgets.add(tab);
    }
    return widgets;
  }

  /// 创建微信文章列表页
  List<Widget> _createPages(List<WechatCount> weChatCounts) {
    List<Widget> widgets = List();
    for (WechatCount count in weChatCounts) {
      var page = WechatArticleListPage(cid: count.id);
      widgets.add(page);
    }
    return widgets;
  }

  /// 获取推荐的微信公众号列表
  Future<List<WechatCount>> getWechatCount() async {
    Response _response;
    await ApiManager().getWechatCount().then((response) {
      _response = response;
    });
    return WechatCountBean.fromJson(_response.data).data;
  }
}