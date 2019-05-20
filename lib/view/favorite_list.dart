import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/favoritedatas_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/favorite_list_item.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';

///收藏列表
class FavoriteList extends StatefulWidget {
  const FavoriteList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoriteListState();
  }
}

class FavoriteListState extends State<FavoriteList> {
  PageStatus status = PageStatus.LOADING;
  int index = 0;
  List<Datas> _dataList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refresh();
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
    });
    _scrollController.addListener(() {
      var maxScrollExtent = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScrollExtent == pixels) {//滑动到底部
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
        break;
      case PageStatus.DATA:
        Widget listView = ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (context, index) {
            return FavoriteListItemWidget(_dataList[index]);
          },
          controller: _scrollController,
        );
        return RefreshIndicator(child: listView, onRefresh: _refresh);
      case PageStatus.ERROR:
        return ErrorView(
          onClick: () {
            _refresh();
          },
        );
        break;
      case PageStatus.EMPTY:
      default:
        return EmptyView(
          iconPath: ImagePath.icEmpty,
          hint: '暂无内容，点击重试',
          onClick: () {
            _refresh();
          },
        );
    }
  }

  ///刷新
  Future<Null> _refresh() async {
    index = 0;
    WanRequest().getFavorite(index).then((data) {
      if (this.mounted) {
        setState(() {
          _dataList = data.datas;
          index++;
          status = _dataList.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
        });
      }
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      status = PageStatus.ERROR;
    });
  }

  ///加载数据
  Future<Null> _loadMore() async {
    WanRequest().getFavorite(index).then((data) {
      setState(() {
        _dataList.addAll(data.datas);
        index++;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }
}