import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/item_wechat_article.dart';
import 'package:wanandroid/widget/loading.dart';
import 'package:wanandroid/widget/pullrefresh/pullrefresh.dart';

/// 公众号文章列表
class WechatArticleListPage extends StatefulWidget {
  final int sid;
  final String keyword;

  WechatArticleListPage({Key key, this.sid, this.keyword: ''}): super(key: key);

  @override
  WechatArticleListState createState() => WechatArticleListState();
}

class WechatArticleListState extends State<WechatArticleListPage> with AutomaticKeepAliveClientMixin {
  PageStatus status = PageStatus.LOADING;
  int index = 1;
  bool hasMoreData = false;
  List<Datas> articles = List();

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
              return WechatArticleItem(articles[position]);
            },
            itemCount: articles.length,
          ),
        );
      case PageStatus.ERROR:
        return ErrorView(onClick: () {
          _refresh();
        });
      case PageStatus.EMPTY:
      default:
        return EmptyView(
          iconPath: ImagePath.icEmpty,
          hint: '暂无内容,点击重试',
          onClick: () {
            _refresh();
          },
        );
    }
  }

  ///刷新
  Future<Null> _refresh() async {
    index = 1;
    WanRequest()
        .getSubscriptionsHistory(index, widget.sid, widget.keyword)
        .then((data) {
      if (this.mounted) {
        setState(() {
          if (data != null && data.datas.length > 0) {
            articles = data.datas;
            if (data.total > articles.length) {
              index++;
              hasMoreData = true;
            } else {
              hasMoreData = false;
            }
            status = articles.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
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
      WanRequest()
          .getSubscriptionsHistory(index, widget.sid, widget.keyword)
          .then((data) {
        setState(() {
          articles.addAll(data.datas);
          if (data.total > articles.length) {
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