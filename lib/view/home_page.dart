import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/constant/textsize_const.dart';
import 'package:flutter_wanandroid_thunderhou/model/home_article_bean.dart';
import 'package:flutter_wanandroid_thunderhou/model/home_banner_bean.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid_thunderhou/net/api_manager.dart';
import 'package:flutter_wanandroid_thunderhou/widget/item_home_article.dart';

/// '首页'页面
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  //首页banner列表
  List<HomeBanner> banners = List();
  //首页article列表
  List<Article> articles = List();
  //文章列表控制器
  ScrollController _scrollController = ScrollController();
  int curPage = 0;
  double screenWidth;
  final double bannerHeight = 180;

  @override
  void initState() {
    super.initState();
    getBanner();
    getArticleList(false);
    _scrollController.addListener(() {
      var maxScrollExtent = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScrollExtent == pixels) {//滑动到底部
        curPage++;
        getArticleList(true);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    Widget listView = ListView.builder(
      itemCount: articles.length + 1,
      itemBuilder: (context, index) {
        return index == 0 ?
          createBannerItem() : HomeArticleItem(articles[index - 1]);
      },
      controller: _scrollController,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('推荐文章'),
        centerTitle: true,//设置标题居中
      ),
      body: RefreshIndicator(child: listView, onRefresh: _pullToRefresh),
    );
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
        scale: 0.8,
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
                    activeSize: 6.0
                  ).build(context, config),
                ),
              )
            ],
          ),
        );
      }
    )
  );

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    await getArticleList(false);
    return null;
  }

  /// 获取首页banner数据
  void getBanner() async {
    Response response = await ApiManager().getHomeBanner();
    var homeBannerBean = HomeBannerBean.fromJson(response.data);
    setState(() {
      banners.clear();
      banners.addAll(homeBannerBean.data);
    });
  }

  /// 获取首页推荐文章数据
  void getArticleList(bool isLoadMore) async {
    Response response = await ApiManager().getHomeArticle(curPage);
    var homeArticleBean = HomeArticleBean.fromJson(response.data);
    setState(() {
      if (!isLoadMore) {
        articles.clear();
      }
      articles.addAll(homeArticleBean.data.datas);
    });
  }

}