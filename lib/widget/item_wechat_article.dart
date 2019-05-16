import 'package:flutter/material.dart';
import 'package:wanandroid/conf/textsize_const.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/view/article_page.dart';

/// 公众号文章列表条目
class WechatArticleItem extends StatefulWidget {
  Datas article;

  WechatArticleItem(this.article);

  @override
  _WechatArticleState createState() => _WechatArticleState();
}

class _WechatArticleState extends State<WechatArticleItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('公众号文章url:${widget.article.link}');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticlePage(
                widget.article.id,
                widget.article.title,
                widget.article.link,
                fav: widget.article.collect,
              ),
            )
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  widget.article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: TextSizeConst.middleTextSize
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
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
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Container(
              color: Colors.grey,
              height: 0.5,
            )
          ],
        ),
      ),
    );
  }
}
