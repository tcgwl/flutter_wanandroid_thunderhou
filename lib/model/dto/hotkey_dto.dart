import 'package:wanandroid/util/string_util.dart';

///搜索热词
class HotKeyDTO {
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotKeyDTO({this.id, this.link, this.name, this.order, this.visible});

  HotKeyDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    name = StringUtil.handleSpecialChar(json['name']);
    order = json['order'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['order'] = this.order;
    data['visible'] = this.visible;
    return data;
  }
}
