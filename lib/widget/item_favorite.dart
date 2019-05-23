import 'package:flutter/material.dart';
import 'package:wanandroid/model/dto/favoritedatas_dto.dart';
import 'package:wanandroid/util/Router.dart';

class FavoriteListItemWidget extends StatefulWidget {
  final Datas data;

  FavoriteListItemWidget(this.data);

  @override
  State<StatefulWidget> createState() {
    return ArticleListItemState();
  }
}

class ArticleListItemState extends State<FavoriteListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            widget.data.title,
            softWrap: true, //是否自动换行
            overflow: TextOverflow.ellipsis, //截断处理
            maxLines: 2,
            style: TextStyle(fontSize: 17),
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            Text(
              '作者：',
            ),
            Expanded(
                child: new Text(
              widget.data.author,
              style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            )),
            Text(
              "时间:" + widget.data.niceDate,
            ),
          ],
        ),
        onTap: () {
          //点击跳转详情
          Router().openWeb(
              context,
              widget.data.id,
              widget.data.title,
              widget.data.link,
              true
          );
        },
        contentPadding:
            EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      ),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
    );
  }
}
