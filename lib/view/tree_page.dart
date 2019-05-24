import 'package:flutter/material.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/model/dto/tree_dto.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/tree_article_page.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/loading.dart';

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TreeState();
}

class TreeState extends State<TreePage> {
  PageStatus status = PageStatus.LOADING;
  List<TreeDTO> dataList;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('体系')),
      body: _buildBody(),
    );
  }

  void _getData() {
    WanRequest().getTree().then((data) {
      setState(() {
        dataList = data;
        status = PageStatus.DATA;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
      case PageStatus.DATA:
        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, i) => buildItem(i),
        );
      case PageStatus.ERROR:
      default:
        return ErrorView(onClick: () => _getData());
    }
  }

  Widget buildItem(index) {
    TreeDTO itemData = dataList[index];

    Text name = Text(
      itemData.name,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: TextSizeConst.middleTextSize,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    );

    List<Treechild> treeChildList = itemData.children;

    String strContent = '';
    for (var treeChild in treeChildList) {
      strContent += '${treeChild.name}   ';
    }

    Text childWidgets = Text(
      strContent,
      softWrap: true,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.left,
    );

    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          _handleOnItemClick(itemData);
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: name,
                    ),
                    childWidgets,
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOnItemClick(TreeDTO data) {
    Router().openPage(context, TreeArticlePage(data));
  }

}