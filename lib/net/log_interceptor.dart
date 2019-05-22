import 'package:dio/dio.dart';
import 'package:wanandroid/util/log_util.dart';

///日志拦截器
class WanLogInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    Log.i('Log\n' +
        '\n:::request===========================================================================' +
        '\napi:' +
        (options.baseUrl + options.path) +
        '\nheaders:' +
        options.headers.toString() +
        '\ndata:' +
        options.data.toString() +
        '\n:::request============================================================================\n');
    return options;
  }

  @override
  onResponse(Response response) {
    Log.i('Log\n' +
        '\n:::response============================================================================' +
        '\nheaders:' +
        response.headers.toString() +
        '\ndata:' +
        response.data.toString() +
        '\n:::response============================================================================\n');
    return response;
  }

  @override
  onError(DioError error) {
    Log.i('Log\n' +
        '\n:::error===========================================================================\n' +
        error.toString() +
        '\n:::error============================================================================\n');
    Log.i(':::error:' + error.toString());
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        throw DioError(message: '连接超时');
        break;
      case DioErrorType.RESPONSE:
        throw DioError(message: '网络错误：' + error.response.statusCode.toString());
        break;
      default:
        throw DioError(message: '网络错误');
        break;
    }
  }

}
