import 'package:flutter/material.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/common_util.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/widget/arc_clipper.dart';
import 'package:wanandroid/widget/pwd_field.dart';

/// '注册'页面
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var screenWidth;
  var screenHeight;
  String _username;
  String _pwd;
  final nameEditController = TextEditingController();
  final pwdEditController = TextEditingController();
  final rePwdEditController = TextEditingController();

  @override
  void dispose() {
    nameEditController.dispose();
    pwdEditController.dispose();
    rePwdEditController.dispose();
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
      appBar: AppBar(
        title: Text(
          '注册'
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildLoginBackground(context),
          _buildLoginCard(context),
        ],
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
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Theme.of(context).primaryColor, Colors.black87]
                  )
              ),
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
      child: SizedBox(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,
        child: Card(
          elevation: 3,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  //用户名
                  TextFormField(
                    controller: nameEditController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: Icon(Icons.person),
                        hintText: '请输入用户名',
                        labelText: '用户名'
                    ),
                    validator: _validateUsername,
                    onSaved: (value) {
                      _username = value;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //密码
                  PasswordField(
                    controller: pwdEditController,
                    border: UnderlineInputBorder(),
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock),
                    labelText: '密码',
                    validator: _validatePwd,
                    onSaved: (value) {
                      _pwd = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //重复密码
                  PasswordField(
                    controller: rePwdEditController,
                    border: UnderlineInputBorder(),
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock),
                    labelText: '重复密码',
                    validator: _validateRePwd,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //注册
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: RaisedButton(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '注册',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: _register,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  ///用户名校验
  String _validateUsername(String value) {
    if (value.isNotEmpty) {
      RegExp nameExp = RegExp(r'^.{6,}$');
      if (nameExp.hasMatch(value)) {
        return null;
      } else {
        return '用户名至少6位';
      }
    }
    return '用户名不能为空';
  }

  ///密码校验
  String _validatePwd(String value) {
    if (value.isNotEmpty) {
      RegExp pwdExp = RegExp(r'^[\w_-]{6,20}$');
      if (pwdExp.hasMatch(value)) {
        return null;
      } else {
        return '密码6~20位且为数字、字母、-、_';
      }
    }
    return '密码不能为空';
  }

  ///密码校验
  String _validateRePwd(String value) {
    if (value.isNotEmpty) {
      if (_pwd != null && _pwd != value) {
        return '两次输入的密码不一致';
      } else {
        return null;
      }
    }
    return '请重新输入密码';
  }

  void _register() {
    print('_register before: _username=$_username, _pwd=$_pwd');
    _username = nameEditController.text;
    _pwd = nameEditController.text;
    print('_register after: _username=$_username, _pwd=$_pwd');

    final FormState form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      CommonUtil.showLoading(context);
      WanRequest().register(_username, _pwd, _pwd).then((result) {
        Router().back(context);
        ToastUtil.showShort('注册成功');
        Router().back(context, result);
      }).catchError((e) {
        Router().back(context);
        ToastUtil.showShort(e.message);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('请检查必填信息'))
      );
    }
  }
}