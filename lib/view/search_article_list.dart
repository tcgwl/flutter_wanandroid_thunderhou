import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/item_home_article.dart';
import 'package:wanandroid/widget/loading.dart';

///搜索文章列表
class ArticleList extends StatefulWidget {
  final id;
  final String keyword;

  const ArticleList({Key key, this.id, this.keyword: ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListState();
  }
}

class ArticleListState extends State<ArticleList>
   with AutomaticKeepAliveClientMixin {
  PageStatus status = PageStatus.LOADING;
  int index = 0;
  List<Datas> articles;
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
        Widget listView = ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return HomeArticleItem(articles[index]);
          },
          controller: _scrollController,
        );
        return RefreshIndicator(child: listView, onRefresh: _refresh);
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

  Future<Null> _refresh() async {
    index = 0;
    WanRequest().search(index, widget.keyword).then((data) {
      if (this.mounted) {
        setState(() {
          articles = data.datas;
          index++;
          status = articles.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
        });
      }
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    WanRequest().search(index, widget.keyword).then((data) {
      setState(() {
        articles.addAll(data.datas);
        index++;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }
}