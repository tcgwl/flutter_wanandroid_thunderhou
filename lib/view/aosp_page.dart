import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/model/project_classify_bean.dart';
import 'package:flutter_wanandroid_thunderhou/net/api_manager.dart';
import 'package:flutter_wanandroid_thunderhou/view/aops_list_page.dart';
import 'package:flutter_wanandroid_thunderhou/widget/async_snapshot_widget.dart';

/// '项目'页面
class AOSPPage extends StatefulWidget {
  @override
  _AOSPPageState createState() => _AOSPPageState();
}

class _AOSPPageState extends State<AOSPPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _tabNames = List<String>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: _buildFuture, future: getProjectClassify());
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot<List<ProjectClassify>> snapshot) {
    return AsyncSnapshotWidget(
      snapshot: snapshot,
      successWidget: (snapshot) {
        if (snapshot.data != null) {
          _parseProjectClassifyList(snapshot.data);

          if (_tabController == null) {
            _tabController = TabController(
                length: snapshot.data.length,
                vsync: this,
                initialIndex: 0
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('项目'),
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

  /// 解析项目分类
  void _parseProjectClassifyList(List<ProjectClassify> projectClassifyList) {
    _tabNames.clear();
    for (ProjectClassify item in projectClassifyList) {
      _tabNames.add(item.name);
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

  /// 创建项目列表页
  List<Widget> _createPages(List<ProjectClassify> projectClassifyList) {
    List<Widget> widgets = List();
    for (ProjectClassify item in projectClassifyList) {
      var page = AOSPListPage(cid: item.id);
      widgets.add(page);
    }
    return widgets;
  }

  /// 获取项目分类
  Future<List<ProjectClassify>> getProjectClassify() async {
    try {
      Response response = await ApiManager().getProjectClassify();
      return ProjectClassifyBean.fromJson(response.data).data;
    } catch (e) {
      return null;
    }
  }
}