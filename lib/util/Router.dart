import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/model/dto/login_dto.dart';
import 'package:wanandroid/view/article_page.dart';
import 'package:wanandroid/view/register_page.dart';
import 'package:wanandroid/view/search_page.dart';

class Router {
  openWeb(BuildContext context, int id, String title, String link, [ bool collect ]) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(
            id,
            title,
            link,
            fav: collect,
          ),
        )
    );
  }

  openSearch(BuildContext context, int type, [ int sId ]) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          if (type == SearchPage.Search_Type_Article) {
            return SearchPage(type);
          } else {
            return SearchPage(type, sId: sId);
          }
        })
    );
  }

  openPage(BuildContext context, Widget widget) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget)
    );
  }

  Future<LoginDTO> openRegister(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => RegisterPage()
        )
    );
  }

  back<T extends Object>(BuildContext context, [ T result ]) {
    Navigator.of(context).pop<T>(result);
  }

}
