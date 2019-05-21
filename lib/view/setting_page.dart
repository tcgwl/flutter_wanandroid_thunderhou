import 'package:flutter/material.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/conf/themes.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/sp_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/about_page.dart';

/// '设置'页面
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _switchDark = false;

  @override
  void initState() {
    super.initState();
    _getTheme();
  }

  void _getTheme() async {
    SpUtil.getBool(Constant.spDarkTheme).then((bool) {
      //根据主题改变开关状态
      _switchDark = bool;
      setState(() {});
    });
  }

  void _setTheme(bool darkTheme) async {
    SpUtil.getInt(Constant.spCurTheme).then((theme) {
      _switchDark = darkTheme;
      setState(() {
        SpUtil.setBool(Constant.spDarkTheme, darkTheme);
        bus.fire(ThemeEvent(theme, darkTheme));
      });
    });
  }

  //选择主题Dialog
  _buildThemesDialogItems() {
    return themes.map((t) => SimpleDialogOption(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: t.data.primaryColor,
            radius: 10,
          ),
          SizedBox(
            width: 10,
          ),
          Text(t.name)
        ],
      ),
      onPressed: () {
        Router().back(context, themes.indexOf(t));
      },
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
          centerTitle: true,//设置标题居中
        ),
        body: Column(
          children: <Widget>[
            _buildItems(),
          ],
        )
    );
  }

  _buildItems() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Image.asset(
                  ImagePath.icTheme,
                  color: Theme.of(context).primaryColorLight,
                  width: 25,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('选择主题'),
                      children: _buildThemesDialogItems(),
                    )
                  ).then((value) {
                    if (value != null) {
                      SpUtil.setBool(Constant.spDarkTheme, false).then((v) {
                        SpUtil.setInt(Constant.spCurTheme, value).then((v) {
                          bus.fire(ThemeEvent(value, false));
                        });
                        _switchDark = false;
                      });

                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    '选择主题',
                    style: TextStyle(fontSize: TextSizeConst.middleTextSize),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '夜间模式',
                      style: TextStyle(fontSize: TextSizeConst.minTextSize),
                    ),
                    Switch.adaptive(
                      value: _switchDark,
                      onChanged: (bool) {
                        _setTheme(bool);
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(),
        _buildInkWell(0, ImagePath.icUpdate, '检查更新'),
        Divider(),
        _buildInkWell(1, ImagePath.icFeedback, '建议与反馈'),
        Divider(),
        _buildInkWell(2, ImagePath.icAbout, '关于'),
        Divider(),
      ],
    );
  }

  _buildInkWell(int position, String iconPath, String title) {
    return InkWell(
      onTap: () {
        if (position == 0) {
          _checkUpdate();
        } else if (position == 1) {
          ToastUtil.showShort('建议与反馈');
          //Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        } else if (position == 2) {
          Router().openPage(context, AboutPage());
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

  _checkUpdate() {
    ToastUtil.showShort('检查更新');
  }
}