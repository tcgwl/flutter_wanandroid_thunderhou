import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/util/sp_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/util/permission_util.dart';
import 'package:wanandroid/view/aosp_page.dart';
import 'package:wanandroid/view/home_page.dart';
import 'package:wanandroid/view/mine_page.dart';
import 'package:wanandroid/view/navigation_page.dart';
import 'package:wanandroid/view/wechat_article_page.dart';
import 'package:wanandroid/conf/themes.dart';
import 'package:wanandroid/conf/constant.dart';

/// 主页
class WanApp extends StatefulWidget {
  @override
  _WanAppState createState() => _WanAppState();
}

class _WanAppState extends State<WanApp> with TickerProviderStateMixin {
  var _titles = ['首页', '导航', '公众号', '项目', '我的']; //导航栏标题
  var _pageController;
  int _tabIndex = 0;
  bool _dark = false;
  int _theme = 0;
  var lastTime = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _getTheme(null);
    bus.on<ThemeEvent>().listen((event) {
      _getTheme(event);
    });
    _initPermission();
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
      theme: _setTheme(),
      // 国际化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US')
      ],
      home: WillPopScope(
        child: _buildBody(),
        onWillPop: () => _exitApp(context)
      ),
    );
  }

  void _initPermission() {
    PermissionUtil.getPermission(FlutterPermissionGroup.storage, (granted) {});
  }

  void _getTheme(ThemeEvent event) {
    if (event != null) {
      _dark = event.darkTheme;
      _theme = event.theme;
      setState(() {});
    } else {
      SpUtil.getBool(Constant.spDarkTheme).then((bool) {
        if (bool) {
          _dark = bool;
          setState(() {});
        } else {
          SpUtil.getInt(Constant.spCurTheme).then((int) {
            _theme = int;
            setState(() {});
          });
        }
      });
    }
  }

  ThemeData _setTheme() {
    if (_dark) {
      return darkTheme.data;
    } else {
      return themes[_theme].data;
    }
  }

  _buildBody() {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          NavPage(),
          WechatArticlePage(),
          AOSPPage(),
          MinePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: _getNavText(0)),
          BottomNavigationBarItem(icon: Icon(Icons.language), title: _getNavText(1)),
          BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy), title: _getNavText(2)),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: _getNavText(3)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: _getNavText(4)),
        ],
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _onTap(index),
        //fixedColor: Colors.blue,
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTime > 1000) {
      lastTime = DateTime.now().millisecondsSinceEpoch;
      print('再按一次退出App');
      ToastUtil.showShort('再按一次退出App');
      return Future.value(false);
    }

    return Future.value(true);
  }

  _getNavText(int index) {
    return Text(
      _titles[index],
      style: TextStyle(fontSize: TextSizeConst.middleTextSize),
    );
  }

  _onTap(int index) {
    setState(() {
      _tabIndex = index;
      _pageController.jumpToPage(index);
    });
  }
}