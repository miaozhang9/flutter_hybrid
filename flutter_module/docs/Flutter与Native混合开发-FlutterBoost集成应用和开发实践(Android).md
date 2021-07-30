### Version 及其变更说明
|  版本  |    日期    |      变更记录      | 作者 |
| :----: | :--------: | :----------------: | :----: |
| V1.0.0 | 2020-08-07 |   Flutter与Native混合开发-FlutterBoost集成应用和开发实践(Android)  | 张淼 |



## 前言补充：

之前我们iOS接入了Flutter_Boost并实践混合开发,这次我们来说下Flutter和Android的Flutter_Boost的混合开发，对flutter boost不了解的可以看上篇。
> 查看上篇：[Flutter与Native混合开发-FlutterBoost集成应用和开发实践(iOS)](https://www.jianshu.com/p/fdd97eea39f5)。FVM和flutter_module也可以参考之前。


## 一、准备工作

### 1.Flutter SDK 

跟之前一样还是先安装本地的fluttersdk，如果需要存在多个版本应对开发不同版本对应，可以安装fluttersdk管理工具fvm。具体查看上一篇的内容。
### 2.flutter boost 

跟之前一样我们还是采用flutter_boost:v1.17.1-hotfixes 和flutter sdk：1.17.1对应的版本关系。

## 二、正式接入

### 1.flutter module工程

1.1直接创建主工程依赖的flutter module工程。

```
flutter create -t module flutter_module
```

支持AndroidX的flutter module

```
flutter create --androidx -t module flutter_module 
```

1.2如果之前存在flutter module且要保证与主项目平级，且在之后android主项目中直接import flutter module。

![目录结构](https://upload-images.jianshu.io/upload_images/1652523-d35294c0fe37d11a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 重点：

不管是新建的module还是本来存在的module，都需要先确认module下`pubspec.yaml`中dev_dependencies内容，修改与自己本地环境对应的版本。

```
dev_dependencies:
  flutter_test:
    sdk: flutter
    
  flutter_boost:
    git:
        url: 'https://github.com/alibaba/flutter_boost.git'
        ref: 'v1.17.1-hotfixes'

```

#### 注意：这里我用的flutter_boost的SDK最新版本：v1.17.1-hotfixes

1.3 更新下载flutter moudle中对应的依赖包（当然如果之前存在可以忽略）

```
flutter package get
```

## 三、Android原生工程

### 1.使用AndroidStudio创建Android原生项目或者使用AndroidStudio打开已存在的项目。

### 2.配置

#### 2.1.settings.gradle
 
```
rootProject.name='FlutterHybridAndroid'
include ':app'
setBinding(new Binding([gradle: this]))
evaluate(new File(
  settingsDir,
  '../flutter_module/.android/include_flutter.groovy'
))


def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

def plugins = new Properties()
def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory
}

```

#### 3.配置app/build.gradle

```
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

//def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
//if (flutterVersionCode == null) {
//    flutterVersionCode = '1'
//}
//
//def flutterVersionName = localProperties.getProperty('flutter.versionName')
//if (flutterVersionName == null) {
//    flutterVersionName = '1.0'
//}

apply plugin: 'com.android.application'
//apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    compileSdkVersion 28


    defaultConfig {
        applicationId "com.example.flutterhybridandroid"
        minSdkVersion 21
        targetSdkVersion 28
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

}

//flutter {
//    source '../..'
//}

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])

    implementation 'androidx.appcompat:appcompat:1.0.2'
    implementation 'androidx.constraintlayout:constraintlayout:1.1.3'
    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'androidx.test.ext:junit:1.1.1'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'

    implementation project(':flutter')
    implementation project(':flutter_boost')

//    debugImplementation project(':flutter')
//    debugImplementation project(':flutter_boost')
////只在编译时有效，不会参与打包
//    compileOnly project(':flutter')
//    compileOnly project(':flutter_boost')

}

```

#### 2.3 local.properties(需要查看local.properties中android sdk和 flutter sdk对应路径)

```
sdk.dir=/Users/xxx/Library/Android/sdk
flutter.sdk=/Users/xxx/.fvm/versions/1.17.1-stable
```

#### 修改完 Android 工程的依赖之后，需要 gradle sync 一下。

#### 项目目录结构如下：
![project结构](https://upload-images.jianshu.io/upload_images/1652523-f44b8600cb29a55e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Android结构](https://upload-images.jianshu.io/upload_images/1652523-9cfc50022a922fc6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 补充：
##### 场景1 AS中创建Flutter module
![新建module](https://upload-images.jianshu.io/upload_images/1652523-ec40466f1dba8d1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![新建module](https://upload-images.jianshu.io/upload_images/1652523-235dc549ba9d82e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ##### 创建后只是单纯的flutter module，如果要接入flutter_boost按照之前讲的配置进行配置即可。

- ##### 新建时路径可以自己安排，如果要和iOS和Android公用一个flutter module需要跟主项目平级最好，如果只是单独一个使用，可以直接创建到主项目中。


##### 场景2 AS中导入已存在的Flutter module（如果已经有存在依赖flutter_boost的flutter_modlue则可以直接import Flutter modlue）

![import](https://upload-images.jianshu.io/upload_images/1652523-bebdd40805db1f0e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 最后都gradle sync 一下即可。

## 三、代码接入实践

#### MyApplication:主要做注册flutter boost插件、注册路由、注册监听相关。

```
package com.example.flutterhybridandroid;

import android.app.Application;
import android.content.Context;
import android.os.Build;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.Platform;
import com.idlefish.flutterboost.Utils;
import com.idlefish.flutterboost.interfaces.INativeRouter;

import java.util.Map;

import io.flutter.embedding.android.FlutterView;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        INativeRouter router =new INativeRouter() {
            @Override
            public void openContainer(Context context, String url, Map<String, Object> urlParams, int requestCode, Map<String, Object> exts) {
                String  assembleUrl= Utils.assembleUrl(url,urlParams);
                PageRouter.openPageByUrl(context,assembleUrl, urlParams);

            }

        };


        FlutterBoost.BoostLifecycleListener boostLifecycleListener= new FlutterBoost.BoostLifecycleListener(){

            @Override
            public void beforeCreateEngine() {

            }

            @Override
            public void onEngineCreated() {

                // 注册MethodChannel，监听flutter侧的getPlatformVersion调用
                MethodChannel methodChannel = new MethodChannel(FlutterBoost.instance().engineProvider().getDartExecutor(), "flutter_native_channel");
                methodChannel.setMethodCallHandler((call, result) -> {

                    if (call.method.equals("getPlatformVersion")) {
                        result.success(Build.VERSION.RELEASE);
                    } else {
                        result.notImplemented();
                    }

                });

                // 注册PlatformView viewTypeId要和flutter中的viewType对应
                FlutterBoost
                        .instance()
                        .engineProvider()
                        .getPlatformViewsController()
                        .getRegistry()
                        .registerViewFactory("plugins.test/view", new TextPlatformViewFactory(StandardMessageCodec.INSTANCE));

            }

            @Override
            public void onPluginsRegistered() {

            }

            @Override
            public void onEngineDestroy() {

            }

        };

        //
        // AndroidManifest.xml 中必须要添加 flutterEmbedding 版本设置
        //
        //   <meta-data android:name="flutterEmbedding"
        //               android:value="2">
        //    </meta-data>
        // GeneratedPluginRegistrant 会自动生成 新的插件方式　
        //
        // 插件注册方式请使用
        // FlutterBoost.instance().engineProvider().getPlugins().add(new FlutterPlugin());
        // GeneratedPluginRegistrant.registerWith()，是在engine 创建后马上执行，放射形式调用
        //

        Platform platform= new FlutterBoost
                .ConfigBuilder(this,router)
                .isDebug(true)
                .whenEngineStart(FlutterBoost.ConfigBuilder.ANY_ACTIVITY_CREATED)
                .renderMode(FlutterView.RenderMode.texture)
                .lifecycleListener(boostLifecycleListener)
                .build();
        FlutterBoost.instance().init(platform);



    }

}

```

#### PageRouter： 路由类

```
package com.example.flutterhybridandroid;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.util.HashMap;
import java.util.Map;

public class PageRouter {

    public final static Map<String, String> pageName = new HashMap<String, String>() {{

        put("first", "first");
        put("second", "second");
        put("tab", "tab");
        put("sample://flutterPage", "flutterPage");
    }};

    public static final String NATIVE_PAGE_URL = "sample://nativePage";
    public static final String FLUTTER_PAGE_URL = "sample://flutterPage";
    public static final String FLUTTER_FRAGMENT_PAGE_URL = "sample://flutterFragmentPage";

    public static boolean openPageByUrl(Context context, String url, Map params) {
        return openPageByUrl(context, url, params, 0);
    }

    public static boolean openPageByUrl(Context context, String url, Map params, int requestCode) {

        String path = url.split("\\?")[0];

        Log.i("openPageByUrl",path);

        try {
            if (pageName.containsKey(path)) {

                Intent intent = BoostFlutterActivity.withNewEngine().url(pageName.get(path)).params(params)
                        .backgroundMode(BoostFlutterActivity.BackgroundMode.opaque).build(context);
                if(context instanceof Activity){
                    Activity activity=(Activity)context;
                    activity.startActivityForResult(intent,requestCode);
                }else{
                    context.startActivity(intent);
                }
                return true;
            } else if (url.startsWith(FLUTTER_FRAGMENT_PAGE_URL)) {
                context.startActivity(new Intent(context, FlutterFragmentPageActivity.class));
                return true;
            } else if (url.startsWith(NATIVE_PAGE_URL)) {
                context.startActivity(new Intent(context, NativePageActivity.class));
                return true;
            }

            return false;

        } catch (Throwable t) {
            return false;
        }
    }
}

```

#### 跳转逻辑：三种跳转方式（原生Page、FlutterPage、Flutter Fragment Page）

```
 if (v == mOpenNative) {
//打开Native页面
            PageRouter.openPageByUrl(this, PageRouter.NATIVE_PAGE_URL , params);
        } else if (v == mOpenFlutter) {
//打开Flutter页面
            PageRouter.openPageByUrl(this, PageRouter.FLUTTER_PAGE_URL,params);
        } else if (v == mOpenFlutterFragment) {
//打开Flutter Fragment 页面
            PageRouter.openPageByUrl(this, PageRouter.FLUTTER_FRAGMENT_PAGE_URL,params);
        }
```

#### 以上基本上是Android原生端的交互实践，具体详细实践还需要看flutter boost官方的example例子，里边很详细。
##### 总体思路就是：先注册flutter相关、然后封装自己路由就可以、

Flutter module项目中代码，跟之前[Flutter与Native混合开发-FlutterBoost集成应用和开发实践(iOS)](https://www.jianshu.com/p/fdd97eea39f5)中的flutter代码内容相同。

flutter项目代码目录（flutter代码跟flutter boost中的example中代码相同，可以看官方例子）：

![flutter目录结构](https://upload-images.jianshu.io/upload_images/1652523-37561c92868e2274.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

到此已经可以实现原生和Flutter_Boost混合实践。








#### 注意事项：
##### 1.Could not resolve io.flutter:flutter_embedding_debug:1.0.0-6bc433c6b6b5b98dc类似问题
```
Could not resolve all files for configuration ':app:debugCompileClasspath'.
> Could not resolve io.flutter:flutter_embedding_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
  Required by:
      project :app
   > Could not resolve io.flutter:flutter_embedding_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/flutter_embedding_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/flutter_embedding_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:flutter_embedding_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/flutter_embedding_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/flutter_embedding_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:flutter_embedding_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/flutter_embedding_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/flutter_embedding_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
> Could not resolve io.flutter:arm64_v8a_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
  Required by:
      project :app
   > Could not resolve io.flutter:arm64_v8a_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/arm64_v8a_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/arm64_v8a_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:arm64_v8a_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/arm64_v8a_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/arm64_v8a_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:arm64_v8a_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/arm64_v8a_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/arm64_v8a_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
> Could not resolve io.flutter:x86_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
  Required by:
      project :app
   > Could not resolve io.flutter:x86_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:x86_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:x86_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
> Could not resolve io.flutter:x86_64_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
  Required by:
      project :app
   > Could not resolve io.flutter:x86_64_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_64_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_64_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:x86_64_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_64_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_64_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
   > Could not resolve io.flutter:x86_64_debug:1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.
      > Could not parse POM http://download.flutter.io/io/flutter/x86_64_debug/1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94/x86_64_debug-1.0.0-e7f9ef6aa0b9040102d1b3c9a6ae934df746ef94.pom
         > Already seen doctype.
```
##### 解决方法：

```
Android项目的build.gradle 

allprojects {
    repositories {
        ......
       //添加这一行
        maven { url "https://storage.googleapis.com/download.flutter.io" }
    }
}
```
参考地址：
[https://github.com/flutter/flutter/issues/39729](https://github.com/flutter/flutter/issues/39729)
[https://blog.csdn.net/jwg1988/article/details/105492110](https://blog.csdn.net/jwg1988/article/details/105492110)


##### 2. 提示JDK位置问题
> Android Studio is using this JDK location: E:\Android Studio\jre

> which is different to what Gradle uses by default:C:\Program Files\Java\jdk1.8.0_131

> Using different locations may spawn multiple Gradle daemons if  Gradle tasks are run from command line while using Android Studio.

#### 解决：
File  -> Other Setting -> Default Project Structure  ->设置JDK location就可以

##### 3.如果你只是单纯的做Flutter开发，使用flutter命令启动运行flutter_module，需要在flutter_module下.android中来添加之前在Android主工程添加的逻辑。否则的话启动起来就是个最原始的flutter页面。可以理解为单独的module开发，分离开发。



参考文章：
[Android与Flutter混合开发之flutter_boost](https://www.jianshu.com/p/d6d7f92952b3)
[Android原生项目引入新版Flutter Module](https://www.jianshu.com/p/a37a2e1c6847)
[在现有应用中加入Flutter支持以及flutter_boost的引入](https://www.jianshu.com/p/6a4edd256520)
[Flutter组件化混合开发-Android](https://www.jianshu.com/p/fd0e0f4d79ba)

![萌图镇楼](https://upload-images.jianshu.io/upload_images/1652523-7d6fc55c279a0033.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
