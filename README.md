# SwiftyTool
个人开发总结，日常开发积累，包含很多有用的分类、功能，不定期更新

# 导入方式
建议使用pod

- 全部模块导入

```
pod 'SwiftyTool', :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- UIKit(与`UIKit`相关的部分)

```
pod "SwiftyTool/UIKit", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- Foundation(与`Foundation`相关的部分)

```
pod "SwiftyTool/Foundation", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- File(文件模块)

```
pod "SwiftyTool/File", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- Log(日志打印模块)，依赖`CocoaLumberjack/Swift`

```
pod "SwiftyTool/Log", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```


- HUD(提示框模块)，依赖`MBProgressHUD`

```
pod "SwiftyTool/HUD", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- NavigationBar(自定义导航栏模块)，依赖`SnapKit`、`GLDeviceTool`

```
pod "SwiftyTool/NavigationBar", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- AsyncDisplayKit，依赖`Texture`

```
pod "SwiftyTool/AsyncDisplayKit", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```


- Map(地图模块)

```
pod "SwiftyTool/Map", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

- SystemFaceKeyboard(系统表情键盘模块)

```
pod "SwiftyTool/SystemFaceKeyboard", :git => "https://github.com/liujunliuhong/SwiftTool.git"
```
- 百度定位:

```
pod 'GLBaiDuLocation', :git => "https://github.com/liujunliuhong/SwiftTool.git"
```

需要在自己的桥接头文件`#import "GLBaiDuLocation.h"`，不可以`import GLBaiDuLocation`

# 本人的其他开源库
### 1、高度还原类似探探等社交应用的滑牌效果。(兼容OC)

[YHDragContainer](https://github.com/liujunliuhong/YHDragContainer)
### 2、轻量级标签选择控件，采用Swift编写，兼容OC
[TagView](https://github.com/liujunliuhong/TagView)
### 3、一个高度自定义的TabBarController组件，继承自UITabBarController
[TabBar](https://github.com/liujunliuhong/TabBar)
### 4、一个好用的社交化组件，目前支持微信
[YHThirdManager](https://github.com/liujunliuhong/YHThirdManager)
### 5、UIDevice扩展，方便获取设备的一些属性，该库会随着Apple每年发布新设备而更新
[DeviceTool](https://github.com/liujunliuhong/DeviceTool)
### 6、对系统权限进行的封装，支持iOS 14。采用Swift编写，不支持OC
[Permission](https://github.com/liujunliuhong/Permission)
### 7、系统UIPickerView、UIDatePicker的封装，国内城市选择器的封装，提供了从屏幕底部逐渐弹出的交互效果
[PickerView](https://github.com/liujunliuhong/PickerView)
### 8、字符串分组排序。可实现通讯录按首字母分组排序，国家省市地区按首字母分组排序等功能。采用Swift编写。不支持OC
[WordsSort](https://github.com/liujunliuhong/WordsSort)



