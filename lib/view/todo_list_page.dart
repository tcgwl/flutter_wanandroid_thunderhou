import 'package:flutter/material.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/conf/page_status.dart';
import 'package:wanandroid/event/event.dart';
import 'package:wanandroid/model/dto/todo_dto.dart';
import 'package:wanandroid/model/dto/todolist_get_dto.dart';
import 'package:wanandroid/model/vo/todolist_vo.dart';
import 'package:wanandroid/net/request.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/toast_util.dart';
import 'package:wanandroid/view/todo_detail_page.dart';
import 'package:wanandroid/widget/empty_view.dart';
import 'package:wanandroid/widget/error_view.dart';
import 'package:wanandroid/widget/item_todo.dart';
import 'package:wanandroid/widget/loading.dart';
import 'package:wanandroid/widget/pullrefresh/pullrefresh.dart';

///待办事项列表
class TodoListPage extends StatefulWidget {
  final int type;
  final TodoListVO vo;

  const TodoListPage(this.type, this.vo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State<TodoListPage> {
  GlobalKey<PullRefreshState> _key = GlobalKey();
  int index = 1;
  List<TodoItem> _listItems;

  GetTodoListDTO _dto = GetTodoListDTO();

  int _status = 0; //默认0:未完成, -1:全部, 1:已完成

  PageStatus status = PageStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _dto.type = widget.type;
    _dto.status = _status;
    _refresh();
    bus.on<EditTodoEvent>().listen((event) {
      if (event.type == widget.type) {
        _dto.type = event.type;
        _refresh();
      }
    });
  }

  ///刷新
  _refresh() async {
    index = 1;
    WanRequest().getTodoList(index, _dto).then((data) {
      if (data.datas != null) {
        if (this.mounted) {
          setState(() {
            _listItems = data.datas.map(
              (TodoDTO dto) => TodoItem(
                dto,
                key: ObjectKey(dto),
              )
            ).toList();
            index++;
            status = _listItems.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
          });
        }
      } else {
        status = PageStatus.EMPTY;
      }
    }).catchError((e) {
      ToastUtil.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  ///加载数据
  _loadMore() async {
    WanRequest().getTodoList(index, _dto).then((data) {
      setState(() {
        _listItems.addAll(data.datas.map(
          (TodoDTO dto) => TodoItem(
            dto,
            key: ObjectKey(dto),
          )
        ).toList());
        index++;
      });
    }).catchError((e) {
      ToastUtil.showShort(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vo.name),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              _dto.orderby = value;
              _refresh();
            },
            itemBuilder: (context) => <PopupMenuItem<int>>[
              PopupMenuItem(
                child: Text('日期逆序'),
                value: _status == 1 ? 2 : 4,
              ),
              PopupMenuItem(
                child: Text('日期顺序'),
                value: _status == 1 ? 1 : 3,
              ),
            ],
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.equalizer),
            onSelected: (value) {
              if (_status != value) {
                _status = value;
                _dto.status = value;
                _refresh();
              }
            },
            itemBuilder: (context) => <PopupMenuItem<int>>[
              _buildPopupMenuItem(0, '未完成'),
              _buildPopupMenuItem(1, '已完成'),
              _buildPopupMenuItem(-1, '全部   '),
            ],
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        //新增
        onPressed: () {
          Router().openPage(context, TodoDetailPage(type: widget.type), true);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
      case PageStatus.DATA:
        return Container(
          child: Hero(
            tag: widget.vo.name,
            child: Container(
              child: PullRefresh(
                key: _key,
                showToTopBtn: false,
                onRefresh: _refresh,
                onLoadmore: _loadMore,
                scrollView: ListView.builder(
                  itemBuilder: (context, index) {
                    return _listItems[index];
                  },
                  itemCount: _listItems.length,
                ),
              ),
            )
          ),
        );
      case PageStatus.ERROR:
        return ErrorView(
          onClick: () {
            _refresh();
          },
        );
      case PageStatus.EMPTY:
      default:
        return Container(
          child: Hero(
              tag: widget.vo.name,
              child: EmptyView(
                iconPath: ImagePath.icTodoEmpty,
                hint: '暂无待办事项',
                onClick: () {
                  Router().openPage(context, TodoDetailPage(type: widget.type), true);
                },
              )
          ),
        );
    }
  }

  _buildPopupMenuItem(int status, String title) {
    return PopupMenuItem(
      value: status,
      child: _status == status
          ? Row(
              children: <Widget>[
                Text(title),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.check)
                ),
              ],
            )
          : Text(title),
    );
  }
}