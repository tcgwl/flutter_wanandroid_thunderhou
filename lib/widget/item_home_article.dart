import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/constant/textsize_const.dart';
import 'package:flutter_wanandroid_thunderhou/model/home_article_bean.dart';
import 'package:flutter_wanandroid_thunderhou/view/webview_page.dart';

/// 首页文章列表条目
class HomeArticleItem extends StatefulWidget {
  final Article article;

  HomeArticleItem(this.article);

  @override
  _HomeArticleState createState() => _HomeArticleState();
}

class _HomeArticleState extends State<HomeArticleItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                    title: widget.article.title,
                    url: widget.article.link
                ),
            )
        );
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Container(
            padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.face,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.article.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ))
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      widget.article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: TextSizeConst.middleTextSize),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            widget.article.niceDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )),
    );
  }
}