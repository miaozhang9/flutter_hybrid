/*
 * @Author: miaoz 
 * @Date: 2020-09-10 17:35:28 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-11-04 10:35:00
 */


import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_module/common/common.dart';
import 'package:flutter_module/http/http.dart';
import 'package:flutter_module/utils/utils.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_boost/flutter_boost.dart';

///公共的拦截
class CommonInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    // TODO: implement onRequest
    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      LogUtilF.v("请求网络异常，请稍后重试！");
      throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    // TODO: implement onResponse

    String statusCode = response.data["code"] as String;
    bool success = response.data["success"] as bool;
    String msg =  response.data["msg"] as String;
    if (!success) {
      //需要退出登陆
      if (statusCode == "4003" ||
          statusCode == "4005" ||
          statusCode == "4006") {
        //提示
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.red,
            // textColor: Colors.white,
            fontSize: 16.0);

        FlutterBoost.singleton.channel.sendEvent(Constant.logoutAndloginFNKey, {'response':response});
        // let error = dealWithError(Int(data.code)!,data.msg)
        // SXLoginServer.shared()?.clearLocalCacheData()
        // let notificationName = Notification.Name(kKickoutNotification)
        // NotificationCenter.default.post(name: notificationName, object: nil)
        // return Result.failure(.underlying(error,nil))
      }
    }

    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    // TODO: implement onError
    return super.onError(err);
  }
}

/// Header拦截器
class HeaderInterceptor extends InterceptorsWrapper {
  static const int _timeout = 1 * 60 * 1000;
  @override
  onRequest(RequestOptions options) async {
    // 设置超时
    options.connectTimeout = HeaderInterceptor._timeout;
    return options;
  }
}

///日志拦截器
///日志方法
void log2Console(Object object) {
  LogUtilF.v(object);
}

class LogInterceptor extends Interceptor {
  ///初始化
  LogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = true,
    this.error = true,
    this.logPrint = log2Console,
  });

  DateTime _startTime;
  DateTime _endTime;

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  Future onRequest(RequestOptions options) async {
    _startTime = DateTime.now();
    logPrint('*** Start ***');
    logPrint('*** Request ***');
    printKV('uri', options.uri);

    if (request) {
      printKV('method', options.method);
      printKV('responseType', options.responseType?.toString());
      printKV('followRedirects', options.followRedirects);
      printKV('connectTimeout', options.connectTimeout);
      printKV('receiveTimeout', options.receiveTimeout);
      printKV('extra', options.extra);
    }
    if (requestHeader) {
      logPrint('headers:');
      options.headers.forEach((key, v) => printKV(" $key", v));
    }
    if (requestBody) {
      logPrint("data:");
      printAll(options.data);
    }
    logPrint("");
  }

  @override
  Future onError(DioError err) async {
    if (error) {
      logPrint('*** DioError ***:');
      logPrint("uri: ${err.request.uri}");
      logPrint("$err");
      if (err.response != null) {
        _printResponse(err.response);
      }
      logPrint("");
    }
  }

  @override
  Future onResponse(Response response) async {
    logPrint("*** Response ***");
    _printResponse(response);
  }

  void _printResponse(Response response) {
    printKV('uri', response.request?.uri);
    if (responseHeader) {
      printKV('statusCode', response.statusCode);
      if (response.isRedirect == true) {
        printKV('redirect', response.realUri);
      }
      if (response.headers != null) {
        logPrint("headers:");
        response.headers.forEach((key, v) => printKV(" $key", v.join(",")));
      }
    }
    if (responseBody) {
      logPrint("Response Text:");
      printAll(response.toString());
    }

    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    logPrint('----------End: $duration 毫秒----------');
    logPrint("");
  }

  ///打印KV
  printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  ///打印全部
  printAll(msg) {
    msg.toString().split("\n").forEach(logPrint);
  }
}
