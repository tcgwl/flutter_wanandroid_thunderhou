import 'package:flutter/material.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/common_util.dart';
import 'package:wanandroid/util/sp_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/favorite_page.dart';
import 'package:wanandroid/view/login_page.dart';
import 'package:wanandroid/view/setting_page.dart';
import 'package:wanandroid/view/todo_page.dart';

/// '抽屉'页面
class MainLeftPage extends StatefulWidget {
  @override
  _MainLeftPageState createState() => _MainLeftPageState();
}

class _MainLeftPageState extends State<MainLeftPage> {
  List<PageInfo> _pageInfoList = new List();
  String _username;
  var statusBarHeight;

  @override
  void initState() {
    super.initState();
    _getUser();
    bus.on<LoginEvent>().listen((event) {
      setState(() {
        if (event.data == null) {
          _getUser();
        } else {
          _username = event.data.username;
        }
      });
    });
    _pageInfoList.add(PageInfo('收藏', ImagePath.icFavorite, FavoritePage()));
    _pageInfoList.add(PageInfo('TODO', ImagePath.icTodo, TodoPage()));
    _pageInfoList.add(PageInfo('设置', ImagePath.icSetting, SettingPage()));
  }

  void _getUser() async {
    SpUtil.getString(Constant.spUserName).then((str) {
      setState(() {
        if (str == null || str.isEmpty) {
          _username = '未登录';
        } else {
          _username = str;
        }
      });
    });
  }

  void _setUser(String value) async {
    SpUtil.setString(Constant.spUserName, value);
  }

  /// 退出登录
  void _logout() {
    CommonUtil.showLoading(context);
    WanRequest().logout().then((res) {
      Router().back(context);
      _setUser('');
      bus.fire(LoginEvent());
      setState(() {
        Constant.isLogin = false;
        _username = '未登录';
      });
    }).catchError((e) {
      Router().back(context);
      ToastUtil.showShort(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHeader(),
          _buildItems(),
        ],
      ),
    );
  }

  /// 用户头像,用户名
  _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight, bottom: 10),
      color: Theme.of(context).primaryColor,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (!Constant.isLogin) {
              Router().openPage(context, LoginPage());
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('确定要退出登录吗?'),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('取消'),
                        onPressed: () => Router().back(context),
                      ),
                      FlatButton(
                          child: const Text('确定'),
                          onPressed: () {
                            Router().back(context);
                            _logout();
                          }
                      ),
                    ],
                  )
              );
            }
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                ImagePath.icAvatar,
                width: 80,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _username == null ? '未登录' : _username,
                style: TextStyle(color: Colors.white, fontSize: TextSizeConst.middleTextSize),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildItems() {
    return Expanded(
      flex: 1,
      child: ListView.builder(
          padding: const EdgeInsets.all(0.0),
          itemCount: _pageInfoList.length,
          itemBuilder: (BuildContext context, int index) {
            PageInfo pageInfo = _pageInfoList[index];
            return ListTile(
              leading: Image.asset(
                pageInfo.iconPath,
                color: Theme.of(context).primaryColorLight,
                width: 25,
              ),
              title: Text(
                pageInfo.title,
                style: TextStyle(fontSize: TextSizeConst.middleTextSize),
              ),
              onTap: () {
                if (pageInfo.title == '设置') {
                  Router().openPage(context, pageInfo.page);
                } else {
                  if (Constant.isLogin) {
                    Router().openPage(context, pageInfo.page);
                  } else {
                    ToastUtil.showShort('请先登录');
                    Router().openPage(context, LoginPage());
                  }
                }
              },
            );
          }
      ),
    );
  }

}

class PageInfo {
  PageInfo(this.title, this.iconPath, this.page, [this.withScaffold = true]);

  String title;
  String iconPath;
  Widget page;
  bool withScaffold;
}