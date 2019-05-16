import 'package:flutter/material.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/model/dto/project_classify_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/aops_list_page.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';

/// '项目'页面
class AOSPPage extends StatefulWidget {
  @override
  _AOSPPageState createState() => _AOSPPageState();
}

class _AOSPPageState extends State<AOSPPage> with SingleTickerProviderStateMixin {
  PageStatus status = PageStatus.LOADING;
  TabController _tabController;
  int _currentPId;
  var _tabs = List<Tab>();
  var _tabPages = List<AOSPListPage>();
  Widget _appbar;

  @override
  void initState() {
    super.initState();
    _appbar = AppBar(title: Text('项目'),);
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
    WanRequest().getProjectClassify().then((data) {
      _tabController = TabController(length: data.length, vsync: this);
      _tabController.addListener(() {
        _currentPId = _tabPages[_tabController.index].pid;
      });
      _tabs = data.map<Tab>(
              (ProjectClassify d) => Tab(text: d.name)
      ).toList();
      _tabPages = data.map<AOSPListPage>(
              (ProjectClassify d) => AOSPListPage(pid: d.id)
      ).toList();

      setState(() {
        _currentPId = _tabPages[_tabController.index].pid;
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
      title: Text('项目'),
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