import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/view/aosp_page.dart';
import 'package:flutter_wanandroid_thunderhou/view/home_page.dart';
import 'package:flutter_wanandroid_thunderhou/view/mine_page.dart';
import 'package:flutter_wanandroid_thunderhou/view/navigation_page.dart';
import 'package:flutter_wanandroid_thunderhou/view/wechat_article_page.dart';

class WanApp extends StatefulWidget {
  @override
  _WanAppState createState() => _WanAppState();
}

class _WanAppState extends State<WanApp> with TickerProviderStateMixin {
  var _pageController;
  int _tabIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterWanAndroid',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            WechatArticlePage(),
            AOSPPage(),
            NavPage(),
            MinePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
            BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy), title: Text('公众号')),
            BottomNavigationBarItem(icon: Icon(Icons.language), title: Text('项目')),
            BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('导航')),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('我的')),
          ],
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => _onTap(index),
          fixedColor: Colors.blue,
        ),
      ),
    );
  }

  _onTap(int index) {
    setState(() {
      _tabIndex = index;
      _pageController.jumpToPage(index);
    });
  }
}