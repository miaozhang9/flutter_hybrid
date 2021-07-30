import 'package:flutter_module/common/common.dart';
import 'package:flutter_module/model/base_entity.dart';
import 'package:flutter_module/model/messageCount_entity.dart';
import 'package:flutter_module/model/todo_entity.dart';

///Json转Model工厂
class EntityFactory {
  ///获取Json解析成model，这里没办法使用泛型，因为T作为List<OBJ>传递进来，没办法获取到OBJ的class
  static _fromJsonSingle(String entityType, json) {
    switch (entityType) {
      case 'MessageCount':
        return MessageCount.fromJson(json as Map<String, dynamic>);
      case 'Todo':
        return Todo.fromJson(json as Map<String, dynamic>);
    }
    return null;
  }

  ///这里处理JSONArray的情况，必须知道List<obj>的类型
  static _getListFromType(String entityType) {
    switch (entityType) {
      case 'MessageCount':
        return List<MessageCount>();
      case 'Todo':
        return List<Todo>();
    }
    return null;
  }

  /// 获取List或者Obj中的Entity.tostring
  static _getEntityFromType<T>() {
    String type = T.toString();
    String entityType = type;
    if (type.contains("List<")) {
      entityType = type.substring(5, type.length - 1);

      ///返回List<obj>中的obj.tostring
      return entityType;
    } else {
      ///返回obj.tostring
      return entityType;
    }
  }

  ///解析List数据和OBJ数据 json=response.data
  static M fromJsonAsM<M>(json) {
    String type = M.toString();
    String entityType = _getEntityFromType<M>() as String;
    if (json[Constant.data] is List && type.contains("List<")) {
      List tempList = _getListFromType(entityType) as List;

      var jsonList = json[Constant.data] as List;
      jsonList.forEach((element) {
        tempList.add(_fromJsonSingle(entityType, element));
      });

      ///以下可以替代上边逻辑，注意这里如果直接返回list会报错，原因是.map最后生成的list是List<dynamic>不能as 成M，否则会报错。
      //  var list = (json[Constant.data] as List).map((e) => _fromJsonSingle(entityType, e)).toList();
      //     list.forEach((element) {
      //       tempList.add(element);
      //     });
      return tempList as M;
    } else {
      ///
      // var resp = BaseResp<M>(json, (res) => _generateOBJ<M>(res));
      var resp = BaseResp<M>(json, (res) => _fromJsonSingle(entityType, res));
      return resp.data;
    }
  }

  ///该方法未实现，原因：T如果是List<obj>,没办法获取到obj的class json=response.data;
  // static T fromJsonAsT<T>(json) {
  //   String type = T.toString();
  //   if (json[Constant.data] is List && type.contains("List<")) {
  //     // (jsonRes[Constant.data] as List).map((e) => null) <T>((ele) => buildFun(ele) as T).toList();
  //     var respList = BaseResp<T>(json, (res) => _generateOBJ<T>(res));
  //     return respList.data as T;
  //   } else {
  //     var resp = BaseResp<T>(json, (res) => _generateOBJ<T>(res));
  //     return resp.data;
  //   }
  // }

  //   static _generateOBJ<T>(json) {
  //   String entityType = _getEntityFromType<T>() as String;
  //   switch (entityType) {
  //     case 'MessageCount':
  //       return MessageCount.fromJson(json as Map<String, dynamic>);
  //     case 'Todo':
  //       return Todo.fromJson(json as Map<String, dynamic>);
  //   }
  //   return null;
  // }
}
