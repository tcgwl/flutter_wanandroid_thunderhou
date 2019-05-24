import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/project_list_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/item_project.dart';
import 'package:wanandroid/widget/loading.dart';
import 'package:wanandroid/widget/pullrefresh/pullrefresh.dart';

/// 项目列表页
class AOSPListPage extends StatefulWidget {
  final int pid;

  AOSPListPage({@required this.pid});

  @override
  _AOSPListState createState() => _AOSPListState();
}

class _AOSPListState extends State<AOSPListPage> with AutomaticKeepAliveClientMixin {
  PageStatus status = PageStatus.LOADING;
  int index = 1;
  bool hasMoreData = false;
  List<Project> projects = List();

  @override
  void initState() {
    super.initState();
    _refresh();
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
      case PageStatus.DATA:
        return PullRefresh(
          onRefresh: _refresh,
          onLoadmore: _loadMore,
          scrollView: ListView.builder(
            itemBuilder: (context, position) {
              return ProjectItem(projects[position]);
            },
            itemCount: projects.length,
          ),
        );
      case PageStatus.ERROR:
        return ErrorView(onClick: _refresh);
      case PageStatus.EMPTY:
      default:
        return EmptyView(
          iconPath: ImagePath.icEmpty,
          hint: '暂无内容,点击重试',
          onClick: _refresh,
        );
    }
  }

  ///刷新
  Future<Null> _refresh() async {
    index = 1;
    if (widget.pid == 0) {
      index = 0;
    }
    WanRequest().getProjectList(widget.pid, index).then((data) {
      if (this.mounted) {
        setState(() {
          if (data != null && data.datas.length > 0) {
            projects = data.datas;
            if (data.total > projects.length) {
              index++;
              hasMoreData = true;
            } else {
              hasMoreData = false;
            }
            status = projects.length == 0 ? PageStatus.EMPTY: PageStatus.DATA;
          } else {
            status = PageStatus.EMPTY;
          }
        });
      }
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  ///加载数据
  _loadMore() async {
    if (hasMoreData) {
      WanRequest().getProjectList(widget.pid, index).then((data) {
        setState(() {
          projects.addAll(data.datas);
          if (data.total > projects.length) {
            index++;
            hasMoreData = true;
          } else {
            hasMoreData = false;
          }
        });
      }).catchError((e) {
        ToastUtil.showShort(e.message);
      });
    } else {
      ToastUtil.showNoMoreData();
    }
  }

}
