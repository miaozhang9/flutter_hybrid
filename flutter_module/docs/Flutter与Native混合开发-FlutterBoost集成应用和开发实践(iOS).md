#Flutter与Native混合开发-FlutterBoost集成应用和开发实践(iOS)
### Version 及其变更说明
|  版本  |    日期    |      变更记录      | 作者 |
| :----: | :--------: | :----------------: | :----: |
| V1.0.0 | 2020-07-22 |   Flutter与Native混合开发-FlutterBoost集成应用和开发实践(iOS)  | 张淼 |


![借图Flutter_Boost](https://upload-images.jianshu.io/upload_images/1652523-d7f4679d7304a23c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 背景：

现在Flutter火热，各个公司都会尝试使用Flutter开发，一般采用的都会是混合形式的开发，混合开发目前Flutter官方提供的不太完善、iOS和Android有差异性、接口也不同意、很麻烦，也有一些大厂为了实现高效率高可用自己实现一套混合开发技术,比如闲鱼的flutter_boost和哈罗的flutter_thrio。两者之间优缺点及设计原理、架构等后续再来具体分析。接下我们先说下flutter_boost在iOS项目中的接入混合实践。

### 准备工作：

#### 1.Flutter SDK

为了便于后续我们flutter sdk版本的快速切换，我们需要安装管理工具，方便我们在后续开发或者调试过程中快速切换版本。

这里推荐使用的Flutter SDK管理工具[fvm](https://github.com/dashixiong91/fvm),能快速切换版本，具体不做介绍，直接去查看文档就可以，很详细。

安装自己所需的flutter sdk版本（我这里安装的是1.17.1版本，因为需要跟下边的flutter_boost版本对应）：
![fvm-flutter](https://upload-images.jianshu.io/upload_images/1652523-df8e1d28b28fee93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
```
####  2.flutter_boost框架

了解混合框架flutter_boost,首先需要知道我们需要使用他们的那个版本及版本对应的flutter sdk版本，比如：flutter_boost:v1.17.1-hotfixes 对应的flutter sdk：1.17.1 。

```
```
### 正式接入：

####  一、flutter_module工程

#####  1.创建空文件夹后，使用命令：

```
flutter create -t module flutter_module
```
如果iOS使用的是Swift开发使用命令：

```
flutter create -i swift -t module flutter_module
```
##### 2.flutter_module创建完成后，打开flutter_module文件夹下`pubspec.yaml`文件。如下：

![pubspec.yaml](https://upload-images.jianshu.io/upload_images/1652523-36a9ee93c61af562.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####  注意：这里我用的flutter_boost的SDK最新版本：v1.17.1-hotfixes

#####  3.cd到flutter_module文件夹下，执行命令：

```
flutter packages get
```
包下载完成后flutter_module工程基本配置已经完成。

#### 二、iOS原生工程

##### 1.创建iOS项目

注意：iOS工程根目录与flutter_module根目录平级。

##### 2.cd到iOS工程目录下创建Podfile文件，执行命令：

`touch Podfile`  生成文件，然后可以使用`vim Podfile` 编辑或者直接`open Podfile` 或者直接打开文本编辑也可以。

在文件中添加

```
flutter_application_path = '../flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
install_all_flutter_pods(flutter_application_path)

```

![pod](https://upload-images.jianshu.io/upload_images/1652523-a00ce27ad05dbca1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 3.执行 `pod install`下载依赖库。

![pod](https://upload-images.jianshu.io/upload_images/1652523-1a8ddc388353e525.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 4.配置项目

如果是OC工程，则不会要做什么额外处理，如果是Swift项目需要建个桥接文件`FlutterHybridiOS-Bridging-Header.h`，同时Build Sttings中需要配置该文件路径。

![swift调用OC桥接文件](https://upload-images.jianshu.io/upload_images/1652523-372a941fdf8997a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![对应路径](https://upload-images.jianshu.io/upload_images/1652523-5a628752dfcaf461.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 注意：

（1）.看其他博客出现过，查看Build Phases中是否存在Flutter Build Script的脚本，如果不存在需要添加对应脚本，但是目前我没出现缺失的情况。

![生成的Flutter Build Script](https://upload-images.jianshu.io/upload_images/1652523-28cada3245aa867e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build

"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed
```

####  三.代码接入实践

这块可以直接下载[flutter_boost官方例子OC](https://github.com/alibaba/flutter_boost/tree/master/example)，[flutter_boost官方例子Swift](https://github.com/alibaba/flutter_boost/tree/master/example_swift)查看具体实践，其中OC例子是最全的，这里只已Swift项目为基础介绍基础使用。

##### <1>.iOS平台

- 1.创建实现flutter_boost路由类，实现FLBPlatform中的协议，和Flutter中也会有对应的方法来处理跳转操作。（直接参考上边官方的代码类就行），即push模式跳转、present模式跳转、关闭页面等方法。

 ```

import Foundation
//import flutter_boost

class PlatformRouterImp: NSObject, FLBPlatform {
    func open(_ url: String, urlParams: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        //跳转打开原生Native页面
        if (url == "native") {
           self.openNativeVC(url, urlParams: urlParams, exts: exts)
           return
        }

        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let vc = FLBFlutterViewContainer.init();
        vc.setName(url, params: urlParams);
        self.navigationController().pushViewController(vc, animated: animated);
        completion(true);
    }
    
    func present(_ url: String, urlParams: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let vc = FLBFlutterViewContainer.init();
        vc.setName(url, params: urlParams);
        navigationController().present(vc, animated: animated) {
            completion(true);
        };
    }
    
    func close(_ uid: String, result: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let presentedVC = self.navigationController().presentedViewController;
        let vc = presentedVC as? FLBFlutterViewContainer;
        if vc?.uniqueIDString() == uid {
            vc?.dismiss(animated: animated, completion: {
                completion(true);
            });
        }else{
            self.navigationController().popViewController(animated: animated);
        }
    }
    
 private func openNativeVC(
        _ name: String?,
        urlParams params: [AnyHashable : Any]?,
        exts: [AnyHashable : Any]?
    ) {
        let vc = UIViewController()
        let animated = (exts?["animated"] as? NSNumber)?.boolValue ?? false
        if (params?["present"] as? NSNumber)?.boolValue ?? false {
            self.navigationController().present(vc, animated: animated) {}
        } else {
      
            self.navigationController().pushViewController(vc, animated: animated)
        }
    }

    func navigationController() -> UINavigationController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = delegate.window?.rootViewController as! UINavigationController
        return navigationController;
    }
}

```

- 2.flutter_boost初始化，即在启动的时候初始化框架代码。

```
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

   override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
          //路由创建
          let router = PlatformRouterImp.init();
          //FlutterBoost初始化
           FlutterBoostPlugin.sharedInstance().startFlutter(with: router, onStart: { (engine) in
            
           });
           
           self.window = UIWindow.init(frame: UIScreen.main.bounds)
           let viewController = ViewController.init()
           let navi = UINavigationController.init(rootViewController: viewController)
           self.window.rootViewController = navi
           self.window.makeKeyAndVisible()
           
        return true
    }

```

- 3.具体使用（创建自己的ViewController，添加两个按钮进行测试跳转Native）

```

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let btn = UIButton(type: .custom);
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: 10, y: 60, width: 60, height: 40)
        btn.setTitle("Push Flutter Page", for: .normal)
        self.view.addSubview(btn);
        btn.addTarget(self, action: #selector(onClickPushFlutterPage), for: .touchUpInside);
        
        let btn2 = UIButton(type: .custom);
        btn2.backgroundColor = UIColor.blue
        btn2.frame = CGRect(x: 10, y: 120, width: 60, height: 40)
        self.view.addSubview(btn2);
        btn2.setTitle("Present Flutter Page", for: .normal)
        btn2.addTarget(self, action: #selector(onClickPresentFlutterPage), for: .touchUpInside);

    }


    @objc func onClickPushFlutterPage(_ sender: UIButton, forEvent event: UIEvent){
//        self.navigationController?.navigationBar.isHidden = true
        //其中这里的first，在Flutter也会对应初始化的时候注册该标识对应的Widget。
         FlutterBoostPlugin.open("first", urlParams:[kPageCallBackId:"MycallbackId#1"], exts: ["animated":true], onPageFinished: { (_ result:Any?) in
             print(String(format:"call me when page finished, and your result is:%@", result as! CVarArg));
         }) { (f:Bool) in
             print(String(format:"page is opened\(f)"));
         }
     }
    @objc func onClickPresentFlutterPage(_ sender: UIButton, forEvent event: UIEvent){
         FlutterBoostPlugin.present("second", urlParams:[kPageCallBackId:"MycallbackId#2"], exts: ["animated":true], onPageFinished: { (_ result:Any?) in
             print(String(format:"call me when page finished, and your result is:%@", result as! CVarArg));
         }) { (f:Bool) in
             print(String(format:"page is presented"));
         }
     }
}

```
###### *注意点：

（1）.调用FlutterBoostPlugin.open和present方法时候，传递的urlname（first、second）会在Flutter中注册对应的Widget。

#####  <2>.Flutter平台

- 1.main.dart （可以理解为入口类，类似iOS中的Appdelete类），实现Flutter_boost初始化和注册Native对应的widget。
（1）初始化flutter_boost插件及注册对应的widgets。
（2）初始化路由router。

```
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'simple_page_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

//（1）初始化注册
    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'first': (String pageName, Map<String, dynamic> params, String _) => FirstRouteWidget(),
      'firstFirst': (String pageName, Map<String, dynamic> params, String _) =>
          FirstFirstRouteWidget(),
      'second': (String pageName, Map<String, dynamic> params, String _) => SecondRouteWidget(),
      'secondStateful': (String pageName, Map<String, dynamic> params, String _) =>
          SecondStatefulRouteWidget(),
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        //（2）初始化路由
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        home: Container(color: Colors.white));
  }

//（2）
  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
}
```
###### 注意点：

(1)`import 'simple_page_widgets.dart'`这个dart类中是实现了很多widget，比如first对应的FirstRouteWidget，second对应的SecondRouteWidget等。但是在实际开发中不要把widget放到一个Dart类种实现，降低代码冗余、代码复杂度、降低维护成本等。

- 2.实现widget（具体可以查看官方类中的simple_page_widgets.dart）
下边只展示我们之前对应的first和second。

```
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module/platform_view.dart'; //封装的view


/// *********************** FirstRouteWidget*/
class FirstRouteWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstRouteWidgetState();
}

class _FirstRouteWidgetState extends State<FirstRouteWidget> {
  _FirstRouteWidgetState();

  // flutter 侧MethodChannel配置，channel name需要和native侧一致
// static const MethodChannel _methodChannel = MethodChannel('flutter_native_channel');
  // String _systemVersion = '';

  // Future<dynamic> _getPlatformVersion() async {

  //   try {
  //     final String result = await _methodChannel.invokeMethod('getPlatformVersion');
  //     print('getPlatformVersion:' + result);
  //     setState(() {
  //       _systemVersion = result;
  //     });
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }

  // }

  @override
  void initState() {
    print('initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(FirstRouteWidget oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('[XDEBUG] - FirstRouteWidget is disposing~');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Open native page'),
              onPressed: () {
                print('open natve page!');
                FlutterBoost.singleton
                    .open('native')
                    .then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve native route result $value');
                });
              },
            ),
            RaisedButton(
              child: const Text('Open FF route'),
              onPressed: () {
                print('open FF page!');
                FlutterBoost.singleton
                    .open('firstFirst')
                    .then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve FF route result $value');
                });
              },
            ),
            RaisedButton(
              child: const Text('Open second route1'),
              onPressed: () {
                print('open second page!');
                FlutterBoost.singleton
                    .open('second')
                    .then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve second route result $value');
                });
              },
            ),
            RaisedButton(
              child: const Text('Present second stateful route'),
              onPressed: () {
                print('Present second stateful page!');
                FlutterBoost.singleton.open('secondStateful',
                    urlParams: <String, dynamic>{
                      'present': true
                    }).then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve second stateful route result $value');
                });
              },
            ),
            RaisedButton(
              child: const Text('Present second route'),
              onPressed: () {
                print('Present second page!');
                FlutterBoost.singleton.open('second',
                    urlParams: <String, dynamic>{
                      'present': true
                    }).then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve second route result $value');
                });
              },
            ),
            RaisedButton(
              child: Text('Get system version by method channel:' + _systemVersion),
              onPressed: () => _getPlatformVersion(),
            ),
          ],
        ),
      ),
    );
  }
}

/// *********************** SecondRouteWidget*/
class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            final BoostContainerSettings settings =
                BoostContainer.of(context).settings;
            FlutterBoost.singleton.close(
              settings.uniqueId,
              result: <String, dynamic>{'result': 'data from second'},
            );
          },
          child: const Text('Go back with result!'),
        ),
      ),
    );
  }
}

```
#####  注意点：

（1）.状态管理的处理，如果细心地同学会发现，上边FirstRouteWidget和SecondRouteWidget的继承类不同，一个是StatelessWidget（非动态的）、StatefulWidget（动态的）两种状态管理。具体理解可以自己去查资料学习，后续也会专门讲下这个。

### 场景：

1.原生-->>原生

这个不多说直接还是原生跳转就行

2.原生-->>Flutter

调用PlatformRouterImp中的方法

3.Flutter-->>原生

需要Flutter代码执行

```
 FlutterBoost.singleton
                    .open('native')
                    .then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve native route result $value');
                });
```

4.Flutter-->>Flutter (走Native原生Controller容器跳转)

```
 FlutterBoost.singleton
                    .open('firstFirst')
                    .then((Map<dynamic, dynamic> value) {
                  print(
                      'call me when page is finished. did recieve FF route result $value');
                });
```

5.Flutter-->>Flutter(走Flutter自己的Flutter Navigator 跳转)

```

 Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(builder: (_) => PushWidget()),
                  );
```

这个自己去做处理，建议既然使用flutter_boost就都采用flutter_boost统一的路有跳转。

如果想实现只打开一个Flutter的原生控制器，其他走flutter内部跳转router逻辑，则需要自己处理，或者也可以看下[flutter_thrio框架](https://github.com/hellobike/flutter_thrio)。


到这里基本上全部工作都可以了，Flutter和iOS都会关联上。直接运行Xcode就可以了。

##### 关于分离开发：
需要注意的地方如果之后考虑分开开发，Flutter同学只开发Flutter的话，需要在flutter_module/.ios/下工程配置之前iOS端的东西即可，就可以使用flutter run直接跑起来，且也能使用flutter_boost路由。做到Flutter开发Flutter，原生开发原生。做到分离。

##### 下一篇会写下Flutter_Boost在Android中的集成应用和代码实践。

![萌图镇楼](https://upload-images.jianshu.io/upload_images/1652523-3a8454dd43998051.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)












