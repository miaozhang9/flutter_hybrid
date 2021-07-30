/*
 * @Author: miaoz 
 * @Date: 2020-08-28 16:21:51 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-11-04 10:27:58
 */

import 'package:flutter/foundation.dart';



class Constant {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static const String data = 'data';
  static const String msg = 'msg';
  static const String code = 'code';
  static const String success = 'success';

  static const String accessToken = 'accessToken';

  static const String searchHistoryListKey = "searchHistoryListKey";
  static const String logoutAndloginFNKey = "logoutAndloginFNKey";
  static const String loginInfoFNKey = "loginInfoFNKey";
  static const String userInfoFNKey = "userInfoFNKey";
  

}


