/*
 * @Author: miaoz 
 * @Date: 2020-08-28 15:57:17 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-09-09 15:48:56
 */

import 'dart:convert' show json;

import 'package:flutter_module/common/common.dart';
// var sss = BaseResp<MessageCount>(responjson, (res) => MessageCount.fromJson(res as Map<String, dynamic>));
// var messageCount = sss.data;
// BaseResp<MessageCount>(data, (res) => MessageCount.fromJson(res as Map<String, dynamic>));
// var data2 = BaseRespList<Todo>(responjson, (res) => Todo.fromJson(res as Map<String, dynamic>));
// List<Todo> todoList = data2.data;
class BaseResp<T> {
  String code;
  String msg;
  bool success;
  T data;

  factory BaseResp(jsonStr, Function buildFun) =>
      jsonStr is String ? BaseResp.fromJson(json.decode(jsonStr), buildFun) : BaseResp.fromJson(jsonStr, buildFun);

  BaseResp.fromJson(jsonRes, Function buildFun) {
    
    code = jsonRes[Constant.code] as String;
    msg = jsonRes[Constant.msg] as String;
  
    success = jsonRes[Constant.success] as bool;

    _check(code, msg);
    data = buildFun(jsonRes[Constant.data]) as T ;
    
  }
}

class BaseRespList<T> {
  String code;
  String msg;
  bool success;
  List<T> data;

  factory BaseRespList(jsonStr, Function buildFun) => jsonStr is String
      ? BaseRespList.fromJson(json.decode(jsonStr), buildFun)
      : BaseRespList.fromJson(jsonStr, buildFun);

  BaseRespList.fromJson(jsonRes, Function buildFun) {
    code = jsonRes[Constant.code] as String;
    msg = jsonRes[Constant.msg] as String;
    success = jsonRes[Constant.success] as bool;
    _check(code, msg);
    data = (jsonRes[Constant.data] as List).map<T>((ele) => buildFun(ele) as T).toList();
  }
}

/// 这里可以做code和msg的处理逻辑
void _check(String code, String msg) {}
