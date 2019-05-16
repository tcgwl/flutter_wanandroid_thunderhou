import 'package:flutter/material.dart';
import 'package:wanandroid/widget/loading.dart';

typedef SuccessWidget = Widget Function(AsyncSnapshot snapshot);

class AsyncSnapshotWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final SuccessWidget successWidget;

  AsyncSnapshotWidget({this.snapshot, @required this.successWidget});

  @override
  Widget build(BuildContext context) {
    return _parseSnap();
  }

  Widget _parseSnap() {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Center(
          child: Text('准备加载...'),
        );
      case ConnectionState.active:
        print('active');
        return Center(
          //child: CircularProgressIndicator(),
          child: Loading(),
        );
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: Loading(),
        );
      case ConnectionState.done:
        print('done');
        return successWidget(snapshot);
      default:
        return Container(width: 0, height: 0);
    }
  }
}