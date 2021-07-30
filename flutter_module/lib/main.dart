
import 'package:flutter_module/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/http/http.dart';
import 'package:flutter_module/http/interceptor.dart';
import 'package:flutter_module/utils/log_util.dart';
import 'package:sp_util/sp_util.dart';
import 'simple_page_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LogUtilF.init(isDebug: true);
  await SpUtil.getInstance();
  //初始化 Http，
  HttpManager().init(
    baseUrl: RequestConstant.baseUrl,
    interceptors: [HeaderInterceptor(), CommonInterceptor(), LogInterceptor()],
  );

  runApp(MyApp());
}

/// APP 主入口
///
/// 本模块函数，加载状态类组件HomePageState
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// App有状态组件类
///
/// 主要是注册FlutterState相关
class _MyAppState extends State<MyApp> {
  /// flutter 侧MethodChannel配置，channel name需要和native侧一致
  static const MethodChannel _methodChannel =
      MethodChannel('flutter_native_channel');

  ///获取请求header
  Future<dynamic> _getRequestHeader() async {
    try {
      return await _methodChannel.invokeMethod('getRequestHeader');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();

    ///注册Pages
    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'embeded': (String pageName, Map<String, dynamic> params, String _) =>
          EmbeddedFirstRouteWidget(),
      'first': (String pageName, Map<String, dynamic> params, String _) =>
          FirstRouteWidget(),
      'firstFirst': (String pageName, Map<String, dynamic> params, String _) =>
          FirstFirstRouteWidget(),
      'second': (String pageName, Map<String, dynamic> params, String _) =>
          SecondRouteWidget(),
      'secondStateful':
          (String pageName, Map<String, dynamic> params, String _) =>
              SecondStatefulRouteWidget(),
      'tab': (String pageName, Map<String, dynamic> params, String _) =>
          TabRouteWidget(),
      'platformView':
          (String pageName, Map<String, dynamic> params, String _) =>
              PlatformRouteWidget(),
      'flutterFragment':
          (String pageName, Map<String, dynamic> params, String _) =>
              FragmentRouteWidget(params),

      ///可以在native层通过 getContainerParams 来传递参数
      'flutterPage': (String pageName, Map<String, dynamic> params, String _) {
        print('flutterPage params:$params');

        return FlutterRouteWidget(params: params);
      },
    });

    ///获取请求Header
    _getRequestHeader()
        .then((value) => {HttpManager().client.options.headers.addAll(value as Map<String, dynamic>)});

    ///注册原生和Flutter监听
    FlutterBoost.singleton
        .addBoostNavigatorObserver(TestBoostNavigatorObserver());

    ///监听生命周期
    FlutterBoost.singleton
        .addBoostContainerLifeCycleObserver((state, settings) {
      // Push, Onstage, Pop, Remove
    });
    //监听Container
    FlutterBoost.singleton.addContainerObserver((operation, settings) {
      // Init,
      // Appear,
      // WillDisappear,
      // Disappear,
      // Destroy,
      // Background,
      // Foreground
    });
    ///Native传递登录信息数据到Flutter
    FlutterBoost.singleton.channel.addEventListener(Constant.loginInfoFNKey,
        (name, arguments) {
      return handleMsg(name, arguments);
    });
    ///Native传递用户信息数据到Flutter
    FlutterBoost.singleton.channel.addEventListener(Constant.userInfoFNKey,
        (name, arguments) {
      return handleMsg(name, arguments);
    });
  }

  Future<dynamic> handleMsg(String name, Map params) {
    print("$name--原生调用flutter-$params");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        // home: CitysFilterWidget());
        // home: BrandsFilterWidget());
    // home: SearchPage());
    home: Container(color: Colors.white));
  }

  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
}

///NavigatorObserver监听
class TestBoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPush');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPop');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didRemove');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print('flutterboost#didReplace');
  }
}
