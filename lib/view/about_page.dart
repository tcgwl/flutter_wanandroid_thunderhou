import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:wanandroid/conf/textsize_const.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutState();
}

class AboutState extends State<AboutPage> {
  String _appName = '';
  String _appVersion = '';

  var screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('关于')
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _appName = info.appName;
        _appVersion = info.version;
      });
    });
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/ic_launcher.png',
                width: 65,
              ),
              Text(
                _appName,
                style: TextStyle(fontSize: TextSizeConst.bigTextSize),
              ),
              Text('v' + _appVersion),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _buildDes(),
      ],
    );
  }

  _buildDes() {
    return SizedBox(
      width: screenWidth * 0.9,
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '说明:',
                style: TextStyle(fontSize: TextSizeConst.middleTextSize),
              ),
              Text('一个简单的玩Android应用'),
              Row(
                children: <Widget>[
                  Text('本项目仅做'),
                  _buildLinkText('Flutter', 'https://flutterchina.club/'),
                  Text('学习交流使用'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'API由WAN ANDROID提供',
                style: TextStyle(fontSize: TextSizeConst.middleTextSize),
              ),
              _buildLinkText('https://www.wanandroid.com', 'https://www.wanandroid.com/blog/show/2'),
              SizedBox(
                height: 10,
              ),
              Text(
                '开源地址',
                style: TextStyle(fontSize: TextSizeConst.middleTextSize),
              ),
              _buildLinkText('https://github.com/tcgwl/flutter_wanandroid_thunderhou',
                  'https://github.com/tcgwl/flutter_wanandroid_thunderhou'),
            ],
          ),
        ),
      ),
    );
  }

  _buildLinkText(String str, String link) {
    return GestureDetector(
      child: Text(str,
          style: TextStyle(
            color: Colors.lightBlue,
            decoration: TextDecoration.underline,
          )),
      onTap: () => launch(link),
    );
  }
}
