import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/model/dto/subscriptionslist_dto.dart';
import 'package:wanandroid/model/dto/tree_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/search_page.dart';
import 'package:wanandroid/view/tree_article_list_page.dart';
import 'package:wanandroid/view/wechat_article_list_page.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';

/// '知识体系'文章页面
class TreeArticlePage extends StatefulWidget {
  final TreeDTO data;

  TreeArticlePage(this.data);

  @override
  _TreeArticlePageState createState() => _TreeArticlePageState();
}

class _TreeArticlePageState extends State<TreeArticlePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _tabs = List<Tab>();
  var _tabPages = List<TreeArticleListPage>();
  Widget _appBar;
  Widget _body;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  _getData() {
    List<Treechild> childList = widget.data.children;
    if (childList.length > 0) {
      _tabController = TabController(length: childList.length, vsync: this);
      _tabs = childList.map<Tab>(
              (Treechild d) => Tab(text: d.name)
      ).toList();
      _tabPages = childList.map<TreeArticleListPage>(
              (Treechild d) => TreeArticleListPage(d.id)
      ).toList();

      _appBar = _buildAppBar();
      _body = TabBarView(
        children: _tabPages,
        controller: _tabController,
      );
    } else {
      _appBar = AppBar(title: Text('体系'));
      _body = EmptyView(
        iconPath: ImagePath.icEmpty,
        hint: '暂无内容,点击重试',
        onClick: () {
          _getData();
        },
      );
    }
  }

  _buildAppBar() {
    return AppBar(
      title: Text(widget.data.name),
      bottom: TabBar(
        tabs: _tabs,
        controller: _tabController,
        isScrollable: true,
      ),
    );
  }

}