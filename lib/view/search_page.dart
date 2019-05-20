import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/model/dto/hotkey_dto.dart';
import 'package:wanandroid/model/vo/flowitem_vo.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/view/search_article_list.dart';
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
  GlobalKey<ArticleListState> _aKey = GlobalKey();
  GlobalKey<WechatArticleListState> _sKey = GlobalKey();
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
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.maybePop(context);
        }
      ),
      title: Theme(
        data: Theme.of(context).copyWith(
          hintColor: Colors.white70,
          textTheme: TextTheme(
            subhead: TextStyle(color: Colors.white)
          )
        ),
        child: TextField(
          autofocus: true,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: '搜索',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                if (_keyword != null && _keyword.isNotEmpty) {
                  _search(_keyword);
                }
              }
            )
          ),
          onChanged: (value) {
            _keyword = value;
          },
        ),
      ),
    );
  }

  _buildBody() {
    if (widget.type == SearchPage.Search_Type_Article) {
      return _keyword == null || _keyword.isEmpty
          ? _hotkeyWidget
          : ArticleList(
              key: _aKey,
              keyword: _keyword,
            );
    } else {
      return _keyword == null || _keyword.isEmpty
          ? Center(
              child: Image.asset(ImagePath.icEmpty),
            )
          : WechatArticleListPage(
              key: _sKey,
              sid: widget.sId,
              keyword: _keyword,
            );
    }
  }

  ///搜索
  void _search(String keyword) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.type == SearchPage.Search_Type_Article) {
      _aKey.currentState.setState(() {});
    } else {
      _sKey.currentState.setState(() {});
    }
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
          _keyword = item.name;
          _search(_keyword);
        },
      );
      setState(() {});
    }).catchError((e) {

    });
  }
}