import 'package:flutter/material.dart';
import 'package:wanandroid/conf/constant.dart';
import 'package:wanandroid/conf/imgs.dart';
import 'package:wanandroid/model/vo/todolist_vo.dart';
import 'package:wanandroid/util/Router.dart';
import 'package:wanandroid/util/sp_util.dart';
import 'package:wanandroid/view/todo_detail_page.dart';
import 'package:wanandroid/view/todo_list_page.dart';

/// 'TODO'页面
class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  var screenWidth;
  List<TodoListVO> categoryList;
  List<IconData> iconList;
  var bgs;
  String _username;

  @override
  void initState() {
    super.initState();
    SpUtil.getString(Constant.spUserName).then((str) {
      setState(() {
        _username = str;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    categoryList = [TodoListVO(0, '默认'), TodoListVO(1, '工作'), TodoListVO(2, '学习'), TodoListVO(3, '生活')];
    iconList = [Icons.all_inclusive, Icons.work, Icons.school, Icons.camera];
    bgs = [ImagePath.bgCardLife, ImagePath.bgCardWork, ImagePath.bgCardStudy, ImagePath.bgCardLife];

    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('TODO'),
          elevation: 3,
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 80.0,
                            height: 80.0,
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  ImagePath.icCartoon,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              _username == null ? 'thunderHou' : _username,
                              style: TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                          Text(
                            "心有猛虎，细嗅蔷薇。",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    //TODO类别
                    Container(
                      height: 350,
                      width: screenWidth,
                      child: _buildTodoList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTodoList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      scrollDirection: Axis.horizontal,
      itemExtent: screenWidth - 80,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Router().openPageWithAnim(context, TodoListPage(index, categoryList[index]));
          },
          child: Hero(//Hero动画
            tag: categoryList[index].name,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Card(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                iconList[index],
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  categoryList[index].name,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                              onPressed: () {
                                Router().openPage(context, TodoDetailPage(type: index));
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(bgs[index]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}