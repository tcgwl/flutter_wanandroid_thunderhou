import 'package:flutter/material.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/model/dto/navi_dto.dart';
import 'package:wanandroid/model/vo/flowitem_vo.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/flow_items.dart';
import 'package:wanandroid/widget/loading.dart';

/// '导航'页面
class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> with SingleTickerProviderStateMixin {
  PageStatus status = PageStatus.LOADING;
  TabController _tabController;
  List<Tab> _tabs = List();
  List<FlowItemsWidget> _tabPages = List();
  Widget _appbar;

  @override
  void initState() {
    super.initState();
    _appbar = AppBar(title: Text('导航'));
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
    WanRequest().getNavi().then((dataList) {
      _tabController = TabController(length: dataList.length, vsync: this);

      _tabs = dataList.map<Tab>(
        (NaviDTO data) => Tab(text: data.name)
      ).toList();

      _tabPages = dataList.map<FlowItemsWidget>(
        (NaviDTO data) => FlowItemsWidget(
          items: data.articles.map(
            (Articles a) => FlowItemVO(a.id, a.title, a.link)
          ).toList(),
          onPress: (item) {
            Router().openWeb(
                context,
                item.id,
                item.name,
                item.link
            );
          },
        )
      ).toList();

      setState(() {
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
      title: Text('导航'),
      bottom: TabBar(
        tabs: _tabs,
        controller: _tabController,
        isScrollable: true,
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