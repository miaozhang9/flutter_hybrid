# Flutter开发调试
### Version 及其变更说明
|  版本  |    日期    |      变更记录      | 作者 |
| :----: | :--------: | :----------------: | :----: |
| V1.0.0 | 2020-08-13 |   Flutter开发调试 | 张淼 |


#### 代码开发后出问题都会需要调试，调试方法很重要。

#### 1. 断点调试

断点调试跟大家熟悉的 Chrome 的断点调试基本一致，核心是在断点处查看当前各个数据的状态情况，但是需要使用 debug 模式运行。

#### 2. debugger调试

代码中增加一个断点语法，可以通过条件式的判断来进行断点，同样需要使用 debug 模式运行。

#### 3.界面调试

为了能够掌握具体的布局问题，在 Web 端，我们可以通过 Chrome 工具进行分析。 Flutter 提供了可视化的界面调试方法。

##### 3.1.使用AndroidStudio工具开发调试

![步骤1](https://upload-images.jianshu.io/upload_images/1652523-2d72b7acfbf7560c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![步骤2](https://upload-images.jianshu.io/upload_images/1652523-63803d56bdc6f65f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 3.2.使用其他开发工具（vscode）

```
flutter pub global activate devtools
```

```
flutter pub global run devtools
```

![控制台](https://upload-images.jianshu.io/upload_images/1652523-abff27d6451be987.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
flutter run -d xx
```

运行项目后会在控制台打印出对应的项目运行后地址

![项目运行后地址](https://upload-images.jianshu.io/upload_images/1652523-a1db9c006e8a30bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 浏览器打开`http://127.0.0.1:9100`

![浏览器添加项目地址](https://upload-images.jianshu.io/upload_images/1652523-76c2af23f8d5d84e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![调试界面](https://upload-images.jianshu.io/upload_images/1652523-1116c0cc13069f22.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上是最终的调试界面，可以来进行调试。
该套工具的详细介绍可以参考[开发者工具](https://flutter.cn/docs/development/tools/devtools)。