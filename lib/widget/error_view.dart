import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';

typedef OnClick = void Function();

class ErrorView extends StatelessWidget {
  final OnClick onClick;

  const ErrorView({Key key, this.onClick}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(ImagePath.icError),
              SizedBox(height: 10,),
              Text('加载失败,点击重试')
            ],
          ),
        ),
      ),
    );
  }
}