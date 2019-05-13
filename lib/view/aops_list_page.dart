import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/model/project_list_bean.dart';
import 'package:flutter_wanandroid_thunderhou/net/api_manager.dart';
import 'package:flutter_wanandroid_thunderhou/widget/item_project.dart';

/// 项目列表页
class AOSPListPage extends StatefulWidget {
  final int cid;

  AOSPListPage({@required this.cid});

  @override
  _AOSPListState createState() => _AOSPListState();
}

class _AOSPListState extends State<AOSPListPage> with AutomaticKeepAliveClientMixin {
  int index = 1;
  List<Project> projects = List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getProjectList(false);
    _scrollController.addListener(() {
      var maxScrollExtent = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScrollExtent == pixels) {
        index++;
        getProjectList(true);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, position) {
        return ProjectItem(projects[position]);
      },
      controller: _scrollController,
    );

    return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
  }

  Future<Null> _pullToRefresh() async {
    index = 1;
    await getProjectList(false);
    return null;
  }

  /// 获取项目列表
  void getProjectList(bool isLoadMore) async {
    await ApiManager().getProjectList(widget.cid, index)
        .then((response){
          if(response != null){
            var projectListBean = ProjectListBean.fromJson(response.data);
            setState(() {
              if (!isLoadMore) {
                projects.clear();
              }
              projects.addAll(projectListBean.data.datas);
            });
          }
    });
  }

}
