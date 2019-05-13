import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_thunderhou/constant/textsize_const.dart';
import 'package:flutter_wanandroid_thunderhou/model/project_list_bean.dart';
import 'package:flutter_wanandroid_thunderhou/view/webview_page.dart';

/// 项目列表条目
class ProjectItem extends StatefulWidget {
  Project project;

  ProjectItem(this.project);

  @override
  State<StatefulWidget> createState() => _ProjectState();
}

class _ProjectState extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('url:${widget.project.link}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                    title: widget.project.title,
                    url: widget.project.link
                )
            )
        );
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Row(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                      width: 120,
                      height: 240,
                      placeholder: "assets/image_default.png",
                      image: widget.project.envelopePic
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 240,
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.project.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: TextSizeConst.middleTextSize
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.perm_identity,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          widget.project.author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.project.desc,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: TextSizeConst.smallTextSize
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.project.niceDate,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  )
                ],
              )
          )
      ),
    );
  }
}
