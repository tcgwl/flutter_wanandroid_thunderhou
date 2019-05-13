/// 微信公众号实体
class WechatCountBean {
  List<WechatCount> data;
  int errorCode;
  String errorMsg;

  WechatCountBean({this.data, this.errorCode, this.errorMsg});

  WechatCountBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<WechatCount>();
      json['data'].forEach((v) {
        data.add(new WechatCount.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class WechatCount {
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  WechatCount(
      {this.courseId,
      this.id,
      this.name,
      this.order,
      this.parentChapterId,
      this.userControlSetTop,
      this.visible});

  WechatCount.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    parentChapterId = json['parentChapterId'];
    userControlSetTop = json['userControlSetTop'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['parentChapterId'] = this.parentChapterId;
    data['userControlSetTop'] = this.userControlSetTop;
    data['visible'] = this.visible;
    return data;
  }

  @override
  String toString() {
    return 'courseId：${courseId}'
          + 'id: ${id}'
          + 'name: ${name}'
          + 'order: ${order}';
  }
}