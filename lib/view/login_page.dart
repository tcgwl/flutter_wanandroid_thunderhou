import 'package:flutter/material.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/login_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/common_util.dart';
import 'package:wanandroid/util/sp_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/register_page.dart';
import 'package:wanandroid/widget/arc_clipper.dart';
import 'package:wanandroid/widget/pwd_field.dart';

/// '登录'页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var screenWidth;
  var screenHeight;
  String _username;
  String _pwd;
  final nameEditController = TextEditingController();
  final pwdEditController = TextEditingController();

  @override
  void dispose() {
    nameEditController.dispose();
    pwdEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return _buildLoginBody(context);
  }

  Widget _buildLoginBody(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildLoginBackground(context),
          _buildLoginCard(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        label: const Text('取消'),
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildLoginBackground(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Theme.of(context).primaryColor, Colors.black87]
                    )
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: screenWidth / 2,
                    height: screenHeight / 8,
                    child: FlutterLogo(
                      colors: Colors.yellow,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container()
        )
      ],
    );
  }

  _buildLoginCard(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              child: Card(
                elevation: 3,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //用户名
                          TextFormField(
                            controller: nameEditController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: '请输入用户名',
                              labelText: '用户名'
                            ),
                            onSaved: (str) {
                              _username = str;
                            },
                          ),
                          //密码
                          PasswordField(
                            controller: pwdEditController,
                            border: UnderlineInputBorder(),
                            fillColor: Colors.transparent,
                            labelText: '密码',
                            onSaved: (str) {
                              _pwd = str;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //登录
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: 35, right: 35),
                              child: RaisedButton(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      '登录',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                onPressed: _login,
                              ),
                            ),
                          ),
                          //注册
                          FlatButton(
                            onPressed: _register,
                            child: Text(
                              '新用户注册',
                              style: TextStyle(
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() {
    print('_login before: _username=$_username, _pwd=$_pwd');
    _username = nameEditController.text;
    _pwd = pwdEditController.text;
    print('_login after: _username=$_username, _pwd=$_pwd');

    if (_username == null || _username.isEmpty) {
      ToastUtil.showShort('请填写用户名');
      return;
    }
    if (_pwd == null || _pwd.isEmpty) {
      ToastUtil.showShort('请填写密码');
      return;
    }
    final FormState form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      CommonUtil.showLoading(context);
      WanRequest().login(_username, _pwd).then((result) {
        Navigator.pop(context);
        ToastUtil.showShort('登录成功');
        Constant.isLogin = true;
        _setUser(result);
        bus.fire(LoginEvent(data: result));
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        ToastUtil.showShort(e.message);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('请检查用户名和密码'))
      );
    }
  }

  void _register() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(),
            fullscreenDialog: true
        )
    ).then((dto) {
      if (dto != null) {
        ToastUtil.showShort('注册成功');
        Constant.isLogin = true;
        _setUser(dto);
        bus.fire(LoginEvent(data: dto));
        Navigator.pop(context);
      }
    });
  }

  void _setUser(LoginDTO user) async {
    SpUtil.setString(Constant.spUserName, user.username);
  }
}