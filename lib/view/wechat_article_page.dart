import 'package:flutter/material.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/model/dto/subscriptionslist_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/search_page.dart';
import 'package:wanandroid/view/wechat_article_list_page.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';

/// '公众号'页面
class WechatArticlePage extends StatefulWidget {
  @override
  _WechatArticlePageState createState() => _WechatArticlePageState();
}

class _WechatArticlePageState extends State<WechatArticlePage> with SingleTickerProviderStateMixin {
  PageStatus status = PageStatus.LOADING;
  TabController _tabController;
  int _currentSId;
  var _tabs = List<Tab>();
  var _tabPages = List<WechatArticleListPage>();
  Widget _appbar;

  @override
  void initState() {
    super.initState();
    _appbar = AppBar(title: Text('公众号'));
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
      appBar: _appbar,
      body: _buildBody(),
    );
  }

  void _getData() async {
    WanRequest().getSubscriptions().then((data) {
      _tabController = TabController(length: data.length, vsync: this);
      _tabController.addListener(() {
        _currentSId = _tabPages[_tabController.index].sid;
      });
      _tabs = data.map<Tab>(
        (SubscriptionsDTO d) => Tab(text: d.name)
      ).toList();
      _tabPages = data.map<WechatArticleListPage>(
          (SubscriptionsDTO d) => WechatArticleListPage(sid: d.id)
      ).toList();

      setState(() {
        _currentSId = _tabPages[_tabController.index].sid;
        _appbar = _buildAppBar();
        status = PageStatus.DATA;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  _buildAppBar() {
    return AppBar(
      title: Text('公众号'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Router().openSearch(context, SearchPage.Search_Type_WeChat, _currentSId);
          }
        )
      ],
      bottom: TabBar(
        tabs: _tabs,
        controller: _tabController,
        isScrollable: true,
        //indicatorColor: Theme.of(context).primaryColor,
        //labelColor: Colors.black87,
        //unselectedLabelColor: Colors.black45,
      ),
    );
  }

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
      case PageStatus.DATA:
        return TabBarView(
          children: _tabPages,
          controller: _tabController,
        );
      case PageStatus.ERROR:
      default:
        return ErrorView(onClick: () => _getData());
    }
  }

}