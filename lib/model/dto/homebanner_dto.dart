import 'package:wanandroid/util/string_util.dart';

///主页banner
class BannerDataDTO {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  BannerDataDTO(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  BannerDataDTO.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    id = json['id'];
    imagePath = json['imagePath'];
    isVisible = json['isVisible'];
    order = json['order'];
    title = StringUtil.handleSpecialChar(json['title']);
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    data['isVisible'] = this.isVisible;
    data['order'] = this.order;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
