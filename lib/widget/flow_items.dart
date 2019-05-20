import 'package:flutter/material.dart';
import 'package:wanandroid/model/vo/flowitem_vo.dart';

typedef PressCallBack = void Function(FlowItemVO item);

class FlowItemsWidget extends StatefulWidget {
  final List<FlowItemVO> items;
  final PressCallBack onPress;

  FlowItemsWidget({Key key, this.items, this.onPress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FlowItemState();
}

class FlowItemState extends State<FlowItemsWidget> {
  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    List<Widget> items = widget.items.map((FlowItemVO data) {
      return RaisedButton(
        onPressed: () => widget.onPress(data),
        child: Text(data.name),
        color: _randomColor(data.name),
        shape: StadiumBorder(),
      );
    }).toList();

    if (items.isNotEmpty) {
      children.add(Wrap(
        children: items.map((Widget widget) {
          return Padding(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            child: widget,
          );
        }).toList(),
      ));
    }
    
    return Card(
      child: ListView(
        children: children,
      ),
    );
  }

  Color _randomColor(name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}