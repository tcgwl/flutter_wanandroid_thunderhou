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

/// '我的'页面
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String _username;

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
    return Scaffold(
        appBar: AppBar(
          title: Text('WanAndroid'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Router().openPage(context, SettingPage());
              }
            )
          ],//设置标题居中
        ),
        body: Column(
          children: <Widget>[
            _buildHeader(),
            _buildItems(),
          ],
        )
    );
  }

  /// 用户头像,用户名
  _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
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
//              Image.asset(
//                ImagePath.icAvatar,
//                width: 80,
//              ),
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      ImagePath.icCartoon,
                    ),
                  ),
                ),
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
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        _buildInkWell(FavoritePage(), ImagePath.icFavorite, '我的收藏'),
        Divider(),
        _buildInkWell(TodoPage(), ImagePath.icTodo, 'TODO'),

      ],
    );
  }

  _buildInkWell(Widget widget, String iconPath, String title) {
    return InkWell( // 带波浪纹
      onTap: () {
        if (Constant.isLogin) {
          Router().openPage(context, widget);
        } else {
          ToastUtil.showShort('请先登录');
          Router().openPage(context, LoginPage());
        }
      },
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Image.asset(
                iconPath,
                color: Theme.of(context).primaryColorLight,
                width: 25,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: TextSizeConst.middleTextSize),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}