import 'package:flutter/material.dart';
import 'package:wanandroid/model/vo/flowitem_vo.dart';
import 'package:wanandroid/util/common_util.dart';

typedef PressCallBack = void Function(FlowItemVO item);

class FlowItemsWidget extends StatefulWidget {
  final List<FlowItemVO> items;
  final PressCallBack onPress;

  FlowItemsWidget({Key key, this.items, this.onPress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FlowItemState();
}

// AutomaticKeepAliveClientMixin: 为避免TarBarView每次切换时其条目Widget都会执行initState()
class FlowItemState extends State<FlowItemsWidget> with AutomaticKeepAliveClientMixin {
  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> items = widget.items.map((FlowItemVO data) {
      return RaisedButton(
        onPressed: () => widget.onPress(data),
        child: Text(data.name),
        color: CommonUtil.randomColor(data.name),
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

  // AutomaticKeepAliveClientMixin: 为避免TarBarView每次切换时其条目Widget都会执行initState()
  @override
  bool get wantKeepAlive => true;

}