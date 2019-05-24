import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/model/dto/hotkey_dto.dart';
import 'package:wanandroid/model/vo/flowitem_vo.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/view/search_list_page.dart';
import 'package:wanandroid/view/wechat_article_list_page.dart';
import 'package:wanandroid/widget/flow_items.dart';

/// '搜索'页面
class SearchPage extends StatefulWidget {
  // 0:文章
  static const Search_Type_Article = 0;
  // 1:公众号
  static const Search_Type_WeChat = 1;
  final int type;
  final int sId;

  SearchPage(this.type, {Key key, this.sId}): super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<FlowItemVO> _hotkeys = List();
  FlowItemsWidget _hotkeyWidget;
  ArticleListPage _articleListPage;
  WechatArticleListPage _wechatArticleListPage;
  TextEditingController _searchController = TextEditingController();
  String _keyword;

  @override
  void initState() {
    super.initState();
    _getHotKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //搜索栏
      appBar: _buildAppbar(),
      //搜索热词 搜索结果
      body: _buildBody(),
    );
  }

  _buildAppbar() {
    TextField searchField = TextField(
      controller: _searchController,
      autofocus: true,
      cursorColor: Colors.white,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '搜索',
      ),
      onSubmitted: (str) {
        _search(str);
      },
    );

    return AppBar(
      title: searchField,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _search(_searchController.text);
          }),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              _searchController.clear();
              _keyword = null;
            });
          }),
      ],
    );
  }

  _buildBody() {
    if (widget.type == SearchPage.Search_Type_Article) {
      return _keyword == null || _keyword.isEmpty
          ? _hotkeyWidget
          : _articleListPage;
    } else {
      return _keyword == null || _keyword.isEmpty
          ? Center(
              child: Image.asset(ImagePath.icEmpty),
            )
          : _wechatArticleListPage;
    }
  }

  ///搜索
  void _search(String keyword) {
    _keyword = keyword;
    setState(() {
      if (widget.type == SearchPage.Search_Type_Article) {
        _articleListPage = ArticleListPage(ValueKey(keyword));
      } else {
        _wechatArticleListPage = WechatArticleListPage(ValueKey('${widget.sId}_$keyword'));
      }
    });
  }

  ///获取热词
  Future<Null> _getHotKey() async {
    WanRequest().getHotKey().then((dataList) {
      _hotkeys = dataList.map(
              (HotKeyDTO data) => FlowItemVO(data.id, data.name, data.link)
      ).toList();

      _hotkeyWidget = FlowItemsWidget(
        items: _hotkeys,
        onPress: (item) {
          _searchController.text = item.name;
          _search(item.name);
        },
      );
      setState(() {});
    }).catchError((e) {

    });
  }
}