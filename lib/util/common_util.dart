import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonUtil {
  static const String CHANNEL_NATIVE = "channel_native";
  static const String METHOD_SHARE = "method_share";
  static const String METHOD_COPY = "method_copy";

  static void share(String msg) {
    MethodChannel(CHANNEL_NATIVE).invokeMethod(METHOD_SHARE, msg);
  }

  static void copy(String msg, String toast) {
    MethodChannel(CHANNEL_NATIVE).invokeMethod(METHOD_COPY, [msg, toast]);
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Card(
              elevation: 5,
              color: Theme.of(context).backgroundColor,
              child: Container(
                width: 70,
                height: 70,
                child: SpinKitCircle(
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  static Color randomColor(name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}