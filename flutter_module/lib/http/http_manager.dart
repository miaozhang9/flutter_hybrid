/*
 * @Author: miaoz 
 * @Date: 2020-08-25 11:29:40 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-11-04 10:18:12
 */
import 'dart:core';
import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter_module/http/http.dart';
import 'package:flutter_module/utils/utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/adapter.dart';
import 'package:flutter_module/http/http_error.dart';
import 'package:flutter_module/model/entity_factory.dart';


import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

///http请求成功回调,目前回调未使用
typedef HttpSuccessCallback<T> = void Function(dynamic data);

///失败回调，目前回调未使用
typedef HttpFailureCallback = void Function(HttpError data);

///数据解析回调，抛给外部使用者自己解析处理。
typedef T JsonParse<T>(dynamic data);

/// 封装 http 请求
/// 1>：首先从本地数据库的缓存中读取数据，如果缓存有数据，就直接显示列表数据，
/// 同时去请求服务器，如果服务器返回数据了，这个时候就去比对服务器返回的数据与缓存中的数据，看是否一样；
/// 2>：如果比对结果是一样，那么直接return返回，不做任何操作；
/// 3>：如果比对结果不一样，就去刷新列表数据，同时把之前数据库中的数据删除，然后存储新的数据；
/// 4>:支持restful请求
/// 5>:统一了post、get、上传和实现了下载
class HttpManager {
  ///同一个CancelToken可以用于多个请求，当一个CancelToken取消时，
  ///所有使用该CancelToken的请求都会被取消，一个页面对应一个CancelToken。
  Map<String, CancelToken> _cancelTokens = Map<String, CancelToken>();

  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;

  ///返回事件
  static const int RECEIVE_TIMEOUT = 30000;

  /// Dio变量
  Dio _client;

  ///HttpManager 实例
  static final HttpManager _instance = HttpManager._internal();

  ///获取http工厂
  factory HttpManager() => _instance;

  ///获取dio实例
  Dio get client => _client;

  /// 创建 dio 实例对象
  HttpManager._internal() {
    if (_client == null) {
      ///BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
      ///BaseOptions 基类请求配置;Options 单次请求配置;RequestOptions 实际请求配置;
      BaseOptions options = BaseOptions(
        ///连接服务器超时时间，单位是毫秒
        connectTimeout: CONNECT_TIMEOUT,

        ///响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: RECEIVE_TIMEOUT,

        ///Http请求头.
        headers: {
          //do something
          "module": "as_flutter_module",
          'device-imei': 'unknown',
          'device-mac': 'unknown',
          'app-id': 'com.ShuXun.SXAutoStreets',
          'app-version-code': '2.7.3',
          // 'login-mark': '',
          'terminal-type': 'mobile',
          'device-number': '1ca83a8ec9ffe77abbe9a6e0ea8f7e50',
          'app-name': 'autostreets',
          'app-version-name': '2.7.3',
          'device-name': 'Testing',
          // 'token': '',
          'device-model': 'iPhone XR',
          'os-name': 'ios',
          'os-version': '14.0'
        },

        ///请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        contentType: Headers.formUrlEncodedContentType,

        ///表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
        responseType: ResponseType.json,
      );
      _client = Dio(options);
      // _client.interceptors.add(LogInterceptor());
      // trustedCertificates(_client);
      //_client.options.headers.addAll(headersMap);
    }
  }

  ///拦截https证书
  void trustedCertificates(Dio dio) {
    /// certificate content  两种校验https方式
    // String PEM = "XXXXX";
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // if (cert.pem == PEM) {
        //   // Verify the certificate
        //   return true;
        // }
        return true;
      };
    };

    ///通过setTrustedCertificates()设置的证书格式必须为PEM或PKCS12，如果证书格式为PKCS12，则需将证书密码传入，这样则会在代码中暴露证书密码，所以客户端证书校验不建议使用PKCS12格式的证书。
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   SecurityContext sc = SecurityContext();
    //   //file is the path of certificate
    //   sc.setTrustedCertificates('file');
    //   HttpClient httpClient = HttpClient(context: sc);
    //   return httpClient;
    // };
  }

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init(
      {String baseUrl,
      int connectTimeout,
      int receiveTimeout,
      List<Interceptor> interceptors}) {
    _client.options = _client.options.merge(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      _client.interceptors..addAll(interceptors);
    }
  }
  ///参数排序和加密
  Map<String, dynamic> parametersEncrypt(Map<String, dynamic> params) {
     //设置默认值
    Map<String, dynamic> _tmpparams = params ?? {};
    _tmpparams['apiKey'] = RequestConstant.apiKey;
    _tmpparams['t'] = DateUtil.getNowDateMs();

    LogUtilF.v("传入的_params${_tmpparams}");

    List<String> keys = _tmpparams.keys.toList();
    // key排序
    keys.sort((a, b) {
      List<int> al = a.codeUnits;
      List<int> bl = b.codeUnits;
      for (int i = 0; i < al.length; i++) {
        if (bl.length <= i) return 1;
        if (al[i] > bl[i]) {
          return 1;
        } else if (al[i] < bl[i]) return -1;
      }
      return 0;
    });
    ///new一个map按照keys的顺序将原先的map数据取出来就可以了。
    var _params = Map();
    keys.forEach((element) {
      _params[element] = _tmpparams[element];
    });

    String clipString = '';
    _params.forEach((key, value) {
       clipString = clipString + '${key}=${value},';
    });

    _params['apiSign'] = StringUtil.generateMD5(clipString.substring(0,clipString.length-1));
    _params.remove('apiKey');

    LogUtilF.v("最终排完序_params${_params}");
    return new Map<String, dynamic>.from(_params);
  }

  ///[method] 请求method
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<T> requestNetwork<T>({
    String method,
    @required String url,
    data,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    String tag,
  }) async {
    return _request(
      url: url,
      method: method,
      data: data,
      params: params,
      options: options,
      jsonParse: jsonParse,
      tag: tag,
    );
  }

  ///统一网络请求
  ///这里合并了普通请求和下载请求
  ///[url] 网络请求地址不包含域名
  ///[data] request data  上传时传的data
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[JsonParse<T> jsonParse] 回调到外部由使用者自己解析
  ///[tag] 请求统一标识，用于取消网络请求
  //////[onSendProgress] 上传进度
  //////[onReceiveProgress] 接收进度进度
  Future<T> _request<T>({
    @required String url,
    String method,
    data,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    String tag,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    ///检查网络是否连接 网络连接统一放到过滤器校验,这里去掉
    // ConnectivityResult connectivityResult =
    //     await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   LogUtilF.v("请求网络异常，请稍后重试！");
    //   throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    // }

    method = method ?? 'GET';

    options?.method = method;

    options = options ??
        Options(
          method: method,
        );

    Map<String, dynamic> _params = parametersEncrypt(params);
    url = _restfulUrl(url, _params);
    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client.request(url,
          queryParameters: _params,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      String statusCode = response.data["code"] as String;
      bool success = response.data["success"] as bool;

      if (success) {
        //成功
        // var sss = EntityFactory.fromJsonAsM<T>(response.data) as List<Todo>;
        if (jsonParse != null) {
          return jsonParse(response.data);
        } else {
          if (T.toString() == 'String') {
            return response.data["data"].toString() as T;
          } else if (T.toString() == 'Map<dynamic, dynamic>') {
            return response.data["data"] as T;
          } else {
            ///走解析，判断list或者obj
            return EntityFactory.fromJsonAsM<T>(response.data);
          }
        }
      } else {
        //失败
        String message = response.data["msg"] as String;
        LogUtilF.v("请求服务器出错：$message");
        //只能用 Future，外层有 try catch
        return Future.error((HttpError(statusCode, message)));
      }
    } on DioError catch (e, s) {
      LogUtilF.v("请求出错：$e\n$s");
      throw (HttpError.dioError(e));
    } catch (e, s) {
      LogUtilF.v("未知异常出错：$e\n$s");
      throw (HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
    }
  }

  ///异步下载文件
  ///
  ///[url] 下载地址
  ///[savePath]  文件保存路径
  ///[onReceiveProgress]  文件保存路径
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<Response> download({
    @required String url,
    @required savePath,
    ProgressCallback onReceiveProgress,
    Map<String, dynamic> params,
    data,
    Options options,
    @required String tag,
  }) async {
    ///检查网络是否连接 网络连接统一放到过滤器校验,这里去掉
    // ConnectivityResult connectivityResult =
    //     await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   LogUtilF.v("请求网络异常，请稍后重试！");
    //   throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    // }
    //设置下载不超时
    int receiveTimeout = 0;
    options ??= options == null
        ? Options(receiveTimeout: receiveTimeout)
        : options.merge(receiveTimeout: receiveTimeout);

    //设置默认值
    params = params ?? {};

    url = _restfulUrl(url, params);

    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      return _client.download(url, savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: params,
          data: data,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e, s) {
      LogUtilF.v("请求出错：$e\n$s");
      throw (HttpError.dioError(e));
    } catch (e, s) {
      LogUtilF.v("未知异常出错：$e\n$s");
      throw (HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
    }
  }

  ///取消网络请求
  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag].isCancelled) {
        _cancelTokens[tag].cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  ///restful处理处理
  String _restfulUrl(String url, Map<String, dynamic> params) {
    // restful 请求处理
    // /gysw/search/hist/:user_id        user_id=27
    // 最终生成 url 为     /gysw/search/hist/27
    params.forEach((key, value) {
      if (url.contains(key)) {
        url = url.replaceAll(':$key', value.toString());
      }
    });
    return url;
  }
}

///Http Mothod 这里可以使用enum和extension替代
class HttpMethod {
  ///post
  static const String POST = 'post';

  ///get
  static const String GET = 'get';
}
