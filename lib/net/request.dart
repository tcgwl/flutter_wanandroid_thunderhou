import 'package:dio/dio.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/model/dto/favoritedatas_dto.dart';
import 'package:wanandroid/model/dto/homebanner_dto.dart';
import 'package:wanandroid/model/dto/hotkey_dto.dart';
import 'package:wanandroid/model/dto/login_dto.dart';
import 'package:wanandroid/model/dto/navi_dto.dart';
import 'package:wanandroid/model/dto/project_classify_dto.dart';
import 'package:wanandroid/model/dto/project_list_dto.dart';
import 'package:wanandroid/model/dto/subscriptions_dto.dart';
import 'package:wanandroid/model/dto/subscriptionslist_dto.dart';
import 'package:wanandroid/model/dto/todo_add_dto.dart';
import 'package:wanandroid/model/dto/todo_dto.dart';
import 'package:wanandroid/model/dto/todo_update_dto.dart';
import 'package:wanandroid/model/dto/todolist_dto.dart';
import 'package:wanandroid/model/dto/todolist_get_dto.dart';
import 'package:wanandroid/model/dto/update_dto.dart';
import 'package:wanandroid/net/request_impl.dart';

abstract class WanRequest {
  static WanRequestImpl _impl;

  WanRequest.internal();

  factory WanRequest() {
    if (_impl == null) {
      _impl = WanRequestImpl();
    }
    return _impl;
  }

  ///获取首页列表
  Future<ArticleDatasDTO> getHomeList(int page);

  ///获取banner
  Future<List<BannerDataDTO>> getHomeBanner();

  ///获取导航数据
  Future<List<NaviDTO>> getNavi();

  ///获取搜索热词
  Future<List<HotKeyDTO>> getHotKey();

  ///搜索
  Future<ArticleDatasDTO> search(int page, String keyword);

  ///获取公众号列表
  Future<List<SubscriptionsDTO>> getSubscriptions();

  ///获取某个公众号历史文章
  Future<ArticleDatasDTO> getSubscriptionsHistory(int page, int id, String keyword);

  ///获取某个公众号的文章列表
  Future<WechatArticleDTO> getSubscriptionArticles(int cid, int page);

  ///获取项目分类
  Future<List<ProjectClassify>> getProjectClassify();

  ///获取项目列表
  Future<ProjectList> getProjectList(int cid, int page);

  ///登录
  Future<LoginDTO> login(String username, String password);

  ///注册
  Future<LoginDTO> register(String username, String password, String repassword);

  ///登出
  Future<Null> logout();

  ///获取收藏列表
  Future<FavoriteDatasDTO> getFavorite(int page);

  ///收藏文章
  Future<Null> favorite(int id);

  ///取消收藏
  Future<Null> favoriteCancel(int id);

  ///获取TODO列表
  Future<TodoListDTO> getTodoList(int page, GetTodoListDTO dto);

  ///更新Todo状态
  Future<TodoDTO> updateTodoStatus(int id, int status);

  ///新增TODO
  Future<TodoDTO> addTodo(AddTodoDTO param);

  ///删除TODO
  Future<Null> deleteTodo(int id);

  ///更新TODO
  Future<TodoDTO> updateTodo(TodoUpdateDTO param);

  ///检测更新
  Future<UpdateDTO> checkUpdate();

  ///下载apk
  Future<Null> downloadApk(String url, ProgressCallback progress);
}