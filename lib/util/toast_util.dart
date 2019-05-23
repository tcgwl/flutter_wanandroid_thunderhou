import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showShort(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1
    );
  }
  static void showNoMoreData() {
    showShort('已经到底啦');
  }
}
