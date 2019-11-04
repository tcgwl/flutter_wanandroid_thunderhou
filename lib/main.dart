import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid/view/main_page.dart';

/// 程序入口
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //竖屏
      .then((_) {
    runApp(WanApp());
  });
}
