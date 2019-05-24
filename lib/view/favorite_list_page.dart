import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/favoritedatas_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/item_favorite.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';
import 'package:wanandroid/widget/pullrefresh/pullrefresh.dart';

///收藏列表
class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoriteListPageState();
  }
}

class FavoriteListPageState extends State<FavoriteListPage> {
  GlobalKey<PullRefreshState> _key = GlobalKey();
  PageStatus status = PageStatus.LOADING;
  int index = 0;
  bool hasMoreData = false;
  List<Datas> _dataList;

  @override
  void initState() {
    super.initState();
    _refresh();
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
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
        return PullRefresh(
            key: _key,
            onRefresh: _refresh,
            onLoadmore: _loadMore,
            scrollView: ListView.builder(
              itemBuilder: (context, index) {
                return FavoriteListItemWidget(_dataList[index]);
              },
              itemCount: _dataList.length,
            )
        );
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
          if (data != null && data.datas.length > 0) {
            _dataList = data.datas;
            if (data.total > _dataList.length) {
              index++;
              hasMoreData = true;
            } else {
              hasMoreData = false;
            }
            status = _dataList.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
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
  Future<Null> _loadMore() async {
    if (hasMoreData) {
      WanRequest().getFavorite(index).then((data) {
        setState(() {
          _dataList.addAll(data.datas);
          if (data.total > _dataList.length) {
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