import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroid/model/dto/articledatas_dto.dart';
import 'package:wanandroid/model/dto/base_dto.dart';
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
import 'package:wanandroid/net/api.dart';
import 'package:wanandroid/net/log_interceptor.dart';
import 'package:wanandroid/net/request.dart';

class WanRequestImpl extends WanRequest {
  Dio _dio;
  WanRequestImpl(): super.internal() {
    var options = BaseOptions(
        baseUrl: WanApi.baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 3000
    );
    _dio = Dio(options);
    _dio.interceptors.add(WanLogInterceptor());

    _setPersistCookieJar();
  }

  _setPersistCookieJar() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    _dio.interceptors.add(CookieManager(PersistCookieJar(dir: path)));
  }

  _handleResponse(Response response) {
    Map<String, dynamic> responseJson;
    if (response.data is String) {
      responseJson = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      responseJson = response.data;
    } else {
      throw DioError(message: '数据解析错误');
    }
    BaseResponseDTO baseDTO = BaseResponseDTO.fromJson(responseJson);
    if (baseDTO.errorCode == 0) {
      return baseDTO.data;
    } else {
      throw DioError(message: baseDTO.errorMsg);
    }
  }

  ///获取首页列表
  @override
  Future<ArticleDatasDTO> getHomeList(int page) async {
    Response response = await _dio.get('${WanApi.homelist}$page/json');
    return ArticleDatasDTO.fromJson(_handleResponse(response));
  }

  ///获取banner
  @override
  Future<List<BannerDataDTO>> getHomeBanner() async {
    Response response = await _dio.get(WanApi.homebanner);
    List<BannerDataDTO> data = new List<BannerDataDTO>();
    _handleResponse(response).forEach((v) {
      data.add(BannerDataDTO.fromJson(v));
    });
    return data;
  }

  ///获取导航数据
  @override
  Future<List<NaviDTO>> getNavi() async {
    Response response = await _dio.get(WanApi.navi);
    List<NaviDTO> data = new List<NaviDTO>();
    _handleResponse(response).forEach((v) {
      data.add(NaviDTO.fromJson(v));
    });
    return data;
  }

  ///获取搜索热词
  @override
  Future<List<HotKeyDTO>> getHotKey() async {
    Response response = await _dio.get(WanApi.hotkey);
    List<HotKeyDTO> data = new List<HotKeyDTO>();
    _handleResponse(response).forEach((v) {
      data.add(HotKeyDTO.fromJson(v));
    });
    return data;
  }

  ///搜索
  @override
  Future<ArticleDatasDTO> search(int page, String keyword) async {
    Response response = await _dio.post(
      '${WanApi.search}$page/json',
      data: FormData.from({'k': keyword})
    );
    return ArticleDatasDTO.fromJson(_handleResponse(response));
  }

  ///获取公众号列表
  @override
  Future<List<SubscriptionsDTO>> getSubscriptions() async {
    Response response = await _dio.get(WanApi.subscriptions);
    List<SubscriptionsDTO> data = new List<SubscriptionsDTO>();
    _handleResponse(response).forEach((v) {
      data.add(SubscriptionsDTO.fromJson(v));
    });
    return data;
  }

  ///获取某个公众号历史文章
  @override
  Future<ArticleDatasDTO> getSubscriptionsHistory(
      int page, int id, String keyword) async {
    Response response = await _dio.get(
        '${WanApi.subscriptionsHis}$id/$page/json',
        queryParameters: {'k': keyword}
    );
    return ArticleDatasDTO.fromJson(_handleResponse(response));
  }

  ///获取某个公众号的文章列表
  @override
  Future<WechatArticleDTO> getSubscriptionArticles(int cid, int page) async {
    Response response = await _dio.get('${WanApi.subscriptionsHis}$cid/$page/json');
    return WechatArticleDTO.fromJson(_handleResponse(response));
  }

  ///获取项目分类
  @override
  Future<List<ProjectClassify>> getProjectClassify() async {
    Response response = await _dio.get(WanApi.projectClassify);
    List<ProjectClassify> data = new List<ProjectClassify>();
    _handleResponse(response).forEach((v) {
      data.add(ProjectClassify.fromJson(v));
    });
    return data;
  }

  ///获取项目列表
  @override
  Future<ProjectList> getProjectList(int cid, int page) async {
    Response response = await _dio.get(
      "${WanApi.projectList}$page/json",
      queryParameters: {"cid": "$cid"}
    );
    return ProjectList.fromJson(_handleResponse(response));
  }

  ///登录
  @override
  Future<LoginDTO> login(String username, String password) async {
    Response response = await _dio.post(
      WanApi.login,
      data: FormData.from({
        'username': username,
        'password': password
      })
    );
    return LoginDTO.fromJson(_handleResponse(response));
  }

  ///注册
  @override
  Future<LoginDTO> register(String username, String password, String repassword) async {
    Response response = await _dio.post(
      WanApi.register,
      data: FormData.from({
        'username': username,
        'password': password,
        'repassword': repassword
      })
    );
    return LoginDTO.fromJson(_handleResponse(response));
  }

  ///登出
  @override
  Future<Null> logout() async {
    Response response = await _dio.get(WanApi.logout);
    return _handleResponse(response);
  }

  ///获取收藏列表
  @override
  Future<FavoriteDatasDTO> getFavorite(int page) async {
    Response response = await _dio.get('${WanApi.favoriteList}$page/json');
    return FavoriteDatasDTO.fromJson(_handleResponse(response));
  }

  ///收藏文章
  @override
  Future<Null> favorite(int id) async {
    Response response = await _dio.post('${WanApi.favorite}$id/json');
    return _handleResponse(response);
  }

  ///取消收藏
  @override
  Future<Null> favoriteCancel(int id) async {
    Response response = await _dio.post('${WanApi.favoriteCancel}$id/json');
    return _handleResponse(response);
  }

  ///获取TODO列表
  @override
  Future<TodoListDTO> getTodoList(int page, GetTodoListDTO dto) async {
    Response response = await _dio.get(
        '${WanApi.todoList}$page/json',
        queryParameters: dto.toJson()
    );
    return TodoListDTO.fromJson(_handleResponse(response));
  }

  ///更新Todo状态
  @override
  Future<TodoDTO> updateTodoStatus(int id, int status) async {
    Response response = await _dio.post(
        '${WanApi.updateTodoStatus}$id/json',
        data: FormData.from({
          'status': status,
        })
    );
    return TodoDTO.fromJson(_handleResponse(response));
  }

  ///新增TODO
  @override
  Future<TodoDTO> addTodo(AddTodoDTO param) async {
    Response response = await _dio.post(
        WanApi.addTodo,
        data: FormData.from(param.toJson())
    );
    return TodoDTO.fromJson(_handleResponse(response));
  }

  ///删除TODO
  @override
  Future<Null> deleteTodo(int id) async {
    Response response = await _dio.post('${WanApi.deleteTodo}$id/json');
    return _handleResponse(response);
  }

  ///更新TODO
  @override
  Future<TodoDTO> updateTodo(TodoUpdateDTO param) async {
    Response response = await _dio.post(
        '${WanApi.updateTodo}${param.id}/json',
        data: FormData.from(param.toJson())
    );
    return TodoDTO.fromJson(_handleResponse(response));
  }

  ///检测更新
  @override
  Future<UpdateDTO> checkUpdate() async {
    Response response = await _dio.get(WanApi.checkUpdate);
    return UpdateDTO.fromJson(_handleResponse(response));
  }

  ///下载apk
  @override
  Future<Null> downloadApk(String url, ProgressCallback progress) async {
    Directory dir = await getExternalStorageDirectory();
    String savePath = '${dir.path}/wanflutter.apk';
    Response response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: progress
    );
  }

}