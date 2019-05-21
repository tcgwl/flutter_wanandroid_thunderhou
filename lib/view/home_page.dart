import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/model/dto/homebanner_dto.dart';
import 'package:wanandroid/net/api.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/main_left_page.dart';
import 'package:wanandroid/view/search_page.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/item_home_article.dart';
import 'package:wanandroid/widget/loading.dart';

/// '首页'页面
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  PageStatus status = PageStatus.LOADING;
  //首页banner列表
  List<BannerDataDTO> banners = List();
  //首页article列表
  List<Datas> articles = List();
  //文章列表控制器
  ScrollController _scrollController = ScrollController();
  int index;
  double screenWidth;
  final double bannerHeight = 180;

  @override
  void initState() {
    super.initState();
    bus.on<LoginEvent>().listen((event) {
      _refresh();
    });
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
    });
    _getPersistCookieJar();

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
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('WanAndroid'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Router().openSearch(context, SearchPage.Search_Type_Article);
            }
          )
        ],
      ),
      body: _buildBody(),
      drawer: Drawer(
        child: MainLeftPage(),
      ),
    );
  }

  Widget _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
      case PageStatus.DATA:
        Widget listView = ListView.builder(
          itemCount: articles.length + 1,
          itemBuilder: (context, index) {
            return index == 0 ?
            createBannerItem() : HomeArticleItem(articles[index - 1]);
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

  Widget createBannerItem() {
    return Container(
      width: screenWidth,
      height: bannerHeight,
      child: banners.length != 0
        ? Swiper(
        autoplay: true,
        autoplayDelay: 3000,
        itemCount: banners.length,
        itemWidth: screenWidth,
        itemHeight: bannerHeight,
        itemBuilder: (context, index) {
          return Image.network(
            banners[index].imagePath,
            fit: BoxFit.fill,
          );
        },
        pagination: _pagination(),
        viewportFraction: 0.8,
        scale: 0.9,
      ) : SizedBox(width: 0, height: 0,)
    );
  }

  SwiperPagination _pagination() => SwiperPagination(
    margin: EdgeInsets.all(0.0),
    builder: SwiperCustomPagination(
      builder: (context, config) {
        return Container(
          color: Colors.black54,
          height: 40,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: <Widget>[
              Text(
                banners[config.activeIndex].title,
                style: TextStyle(
                  fontSize: TextSizeConst.smallTextSize,
                  color: Colors.white
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DotSwiperPaginationBuilder(
                    color: Colors.white70,
                    activeColor: Colors.green,
                    size: 6.0,
                    activeSize: 8.0
                  ).build(context, config),
                ),
              )
            ],
          ),
        );
      }
    )
  );

  _getPersistCookieJar() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    PersistCookieJar pcj = new PersistCookieJar(dir: path);
    List<Cookie> cs = pcj.loadForRequest(Uri.parse(WanApi.baseUrl + WanApi.login));
    if (cs != null && cs.length > 0) {
      cs.forEach((cookie) {
        if (cookie.name == Constant.tokenPass) {
          Constant.isLogin = true;
          bus.fire(LoginEvent());
        }
      });
      if (!Constant.isLogin) {
        _refresh();
      }
    } else {
      _refresh();
    }
  }

  //刷新
  Future<Null> _refresh() async {
    index = 0;
    WanRequest().getHomeBanner().then((data) {
      if (this.mounted) {
        setState(() {
          banners = data;
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
    WanRequest().getHomeList(index).then((data) {
      if (this.mounted) {
        setState(() {
          articles = data.datas;
          index++;
          status = articles.length == 0 ? PageStatus.EMPTY: PageStatus.DATA;
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
  _loadMore() async {
    WanRequest().getHomeList(index).then((data) {
      setState(() {
        articles.addAll(data.datas);
        index++;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }

}