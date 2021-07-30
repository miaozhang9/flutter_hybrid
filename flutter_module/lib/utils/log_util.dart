/*
 * @Author: miaoz 
 * @Date: 2020-08-25 13:42:16 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-08-26 16:35:01
 */
///日志Util
class LogUtilF {
  static const String _TAG_DEFAULT = "as_flutter_module";

  ///是否 debug
  static bool debug = true; //是否是debug模式,true: log v 不输出.
  ///标识
  static String tagDefault = _TAG_DEFAULT;
  ///日志util init
  static void init({bool isDebug = false, String tag = _TAG_DEFAULT}) {
    debug = isDebug;
    tag = tag;
  }
  /// e 日志输出
  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }
  /// v 日志输出
  static void v(Object object, {String tag}) {
    if (debug) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? tagDefault : tag);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}
