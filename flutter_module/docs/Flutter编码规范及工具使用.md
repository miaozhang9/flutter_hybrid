# Flutter编码规范及工具使用

### Version 及其变更说明
|  版本  |    日期    |      变更记录      | 作者 |
| :----: | :--------: | :----------------: | :----: |
| V1.0.0 | 2020-09-11 |   Flutter编码规范及工具使用 | 张淼 |


### 最近学习听课，讲师讲了下编码规范及相对应对检测工具讲解，及自己的理解在这里分享下。

## 命名规范

命名规范中包括了文件以及文件夹的命名规范，常量和变量的命名规范，类的命令规范。Dart 中只包含这三种命名标识。

- AaBb 类规范，首字母大写驼峰命名法，例如 IsClassName，常用于类的命名。

- aaBb 类规范，首字母小写驼峰命名法，例如 isParameterName，常用于常量以及变量命名。

- aa_bb 类规范，小写字母下划线连接法，例如 is_a_flutter_file_name，常用于文件及文件夹命名。

## 注释规范

注释的目的是生成我们需要的文档，从而增强项目的可维护性。

### 单行注释

单行注释主要是“ // ”这类标示的注释方法，这类注释与其他各类语言使用的规范一致。单行注释主要对于单行代码逻辑进行解释，为了避免过多注释，主要是在一些理解较为复杂的代码逻辑上进行注释。

比如，下面这段代码没有注释，虽然你看上下文也会知道这里表示的是二元一次方程的 ∆ ，但是却不知道如果 ∆ 大于 0 ，为什么 x 会等于 2。

```
if ( b * b - 4 * a * c > 0 ) {
  x = 2;
}
```
如果加上注释则显得逻辑清晰容易理解，修改后如下所示。

```
// 当∆大于0则表示方程x个解，x则为2
if ( b * b - 4 * a * c > 0 ) {
  x = 2;
}
```
虽然单行注释大家都比较了解，但我这里还是多解释了下如何应用，主要是希望大家规范化使用，减少不必要的代码注释。

### 多行注释

在 Dart 中由于历史原因（前后对多行注释方式进行了修改）有两种注释方式，一种是 /// ，另外一种则是 / **......* / 或者 /*......*/ ，这两种都可以使用。/**......*/ 和 /*......*/ 这种块级注释方式在其他语言（比如 JavaScript ）中是比较常用的，但是在 Dart 中我们更倾向于使用 /// ，后续我们所有的代码都按照这个规范来注释。

多行注释涉及类的注释和函数的注释。两者在注释方法上一致。首先是用一句话来解释该类或者函数的作用，其次使用空行将注释和详细注释进行分离，在空行后进行详细的说明。如果是类，在详细注释中，补充该类作用，其次应该介绍返回出去的对象功能，或者该类的核心方法。如果是函数，则在详细注释中，补充函数中的参数以及返回的数据对象。

假设有一个 App 首页的库文件，其中包含类 HomePage ， HomePage 中包含两个方法，一个是 getCurrentTime ，另一个是 build 方法，代码注释如下（未实现其他部分代码）。


```
import 'package:flutter/material.dart';
/// APP 首页入口
/// 
/// 本模块函数，加载状态类组件HomePageState
class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}
/// 首页有状态组件类
///
/// 主要是获取当前时间，并动态展示当前时间
class HomePageState extends State<HomePage> {
  /// 获取当前时间戳
  ///
  /// [prefix]需要传入一个前缀信息
  /// 返回一个字符串类型的前缀信息：时间戳
  String getCurrentTime(String prefix) {
  }
  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
  }
}
```

### 注释文档生成

根据上面的代码注释内容，我们利用一个官方工具来将当前项目中的注释转化为文档。
打开命令行工具进入当前项目，或者在 Android Studio 点击界面上的 Terminal 打开命令行窗口，运行如下命令。

```
dartdoc
```
运行结束后，会在当前项目目录生成一个 doc 的文件夹。

![生成目录文件](https://upload-images.jianshu.io/upload_images/1652523-15838c037e1578ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在生成文件夹中，可以直接打开 doc/api/index.html 文件。
![生成的doc](https://upload-images.jianshu.io/upload_images/1652523-31fde1e49731b45a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上是使用标准的代码注释生成的文档，利用这种方式将大大提升项目的可维护性，在项目初期就要做好此类规范。

## 库引入规范

Dart 为了保持代码的整洁，规范了 import 库的顺序。将 import 库分为了几个部分，每个部分使用空行分割。分为 dart 库、package 库和其他的未带协议头（例如下面中的 util.dart ）的库。其次相同部分按照模块的首字母的顺序来排列，例如下面的代码示例：

```
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:two_you_friend/pages/home_page.dart';
import 'util.dart';
```

## 代码美化

在 Dart 中同样有和前端一样的工具 pritter ，在 Dart 中叫作 dartfmt ，该工具和 dartdoc 一样，已经包含在 Dart SDK 中，因此可以直接运行如下命令检查是否生效。

```
dartfmt -h
```

既然有此类工具，我们就来看下如何应用工具来规范和美化我们的代码结构。

### dartfmt

dartfmt 工具的规范包括了以下几点：

- 使用空格而不是 tab；

- 在一个完整的代码逻辑后面使用空行区分；

- 二元或者三元运算符之间使用空格；

- 在关键词 , 和 ; 之后使用空格；

- 一元运算符后请勿使用空格；

- 在流控制关键词，例如 for 和 while 后，使用空格区分；

- 在 ( [ { } ] ) 符号后请勿使用空格；

- 在 { 后前使用空格；

- 使用 . 操作符，从第二个 . 符号后每次都使用新的一行。

- 其他规范可以参考 [dartfmt 的官网](https://github.com/dart-lang/dart_style/wiki/Formatting-Rules)。了解完以上规范后，我们现在将上面的 home_page.dart 进行修改，将部分代码修改为不按照上面规范的结构，代码修改如下：

```
import 'package:flutter/material.dart';
/// APP 首页入口
///
/// 本模块函数，加载状态类组件HomePageState
class HomePage extends StatefulWidget{
  @override
  createState() => new HomePageState();
}
/// 首页有状态组件类
///
/// 主要是获取当前时间，并动态展示当前时间
class HomePageState extends State<HomePage> {
  /// 获取当前时间戳
  ///
  /// [prefix]需要传入一个前缀信息
  /// 返回一个字符串类型的前缀信息：时间戳
  String getCurrentTime( String prefix ) {
  }
  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
  }
}
```

上面 getCurrentTime 的参数和 { 没有按照 dartfmt 规范来处理，在当前目录下打开 Terminal，然后先运行以下命令来修复当前的代码规范：


```
 dartfmt -w --fix lib/
```

{ 前无空格问题，和 getCurrentTime 参数空格问题，会被修复，说白了就是格式化代码。

## 工具化

在 Dart 中同样存在和 eslint 一样的工具 dartanalyzer 来保证代码质量（但是只是静态的检测）。

该工具（ dartanalyzer ）已经集成在 Dart SDK ，你只需要在 Dart 项目根目录下新增analysis_options.yaml 文件，然后在文件中按照规范填写你需要执行的规则检查即可，目前现有的检查规则可以参考 [Dart linter rules](https://dart-lang.github.io/linter/lints/) 规范。

为了方便，我们可以使用现成已经配置好的规范模版，这里有两个库 pedantic 和 effective_dart 可以参照使用。如果我们需要在项目中，使用它们两者之一，可以在项目配置文件（ pubspec.yaml ）中新增如下两行配置：

```
dependencies:
  flutter:
    sdk: flutter
  pedantic: ^1.9.2
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.2
dev_dependencies:
  flutter_test:
    sdk: flutter
  pedantic: ^1.9.2
```


配置完成以后，在当前项目路径下运行 flutter pub upgrade 。接下来在本地新增的 analysis_options.yaml 文件中新增如下配置：


```
include: package:pedantic/analysis_options.1.9.2.yaml

```

如果我们认为 pedantic 不满足我们的要求，我们再根据 Dart linter rules 规范，前往选择自己需要的规范配置，修改下面的配置：

```
include: package:pedantic/analysis_options.1.8.0.yaml
analyzer:
  strong-mode:
    implicit-casts: false
linter:
  rules:
    # STYLE
    - camel_case_types
    - camel_case_extensions
    - file_names
    - non_constant_identifier_names
    - constant_identifier_names # prefer
    - directives_ordering
    - lines_longer_than_80_chars # avoid
    # DOCUMENTATION
    - package_api_docs # prefer
    - public_member_api_docs # prefer


```

我在 pedantic 的基础上又增加了一些对于样式和文档的规范，增加完成以上配置后，运行如下命令可进行检查。


```
dartanalyzer lib
```


控制台输出

```
 lint • Document all public members. • lib/platform_view.dart:8:7 • public_member_api_docs
```

意思就是：需要添加注释。

```
 lint • AVOID lines longer than 80 characters. • lib/simple_page_widgets.dart:81:1 • lines_longer_than_80_chars
```

意思是：每行超过了80字符，因为我们的规范是80字符。

当然还会有其他问题，每个团队都有自己对应的规则，根据自己匹配的规则进行修改。

总结，我们需要记住基础规范及配置的规则和对应的命令。

```
基础规范：规定基础的代码规范。
dartdoc :对代码和注释输出文档，这个很方便，只要注释全，完全就是成品文档，所以最开始就要养成良好注释和编码习惯。
dartfmt -w --fix lib/:美化、格式化lib下代码。
dartanalyzer lib:根据编码规范规则进行检测修改lib下的代码规范。前提需要配置`pubspec.yaml `和添加`analysis_options.yaml `.
```




