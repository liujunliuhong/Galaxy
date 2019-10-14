# SwiftTool
Swift版本的开发工具，旨在帮助开发人员快速开发，未完，持续更新中...

## 由于经常更新，不支持pod，请手动导入
## 使用到的三方库:
```
# Swift
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'NSObject+Rx'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Result'
  pod 'CocoaLumberjack/Swift'
```
## 请在自己项目的桥接文件里面引入`#import "YHSwiftTool_OC_Header.h"`
```
桥接文件设置:TARGETS -> Build Settings -> 搜索Swift Compiler -> 找到Objective-C bridging Header，然后就可以设置自己的桥接文件或者更改桥接文件名
```







# YHTabBarController
> 参考了一个第三方：[ESTabBarController](https://github.com/eggswift/ESTabBarController)，在此表示感谢，通过阅读源码，我在其基础上做了很多改进，另外自定义tabBar还有个写的比较好的：[CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)，不过在使用过程中遇到了好些坑，并且升级到iOS 13之后竟然崩溃，也许是我项目里面其他代码导致的。因此我打算自己写一个(又在造轮子了...不过自定义tabBar是我很早之前就有这么个想法，只是一直没有付诸实施，正好这次把它写出来)

### 特点



# YHDragCard
> 模仿探探写的一个卡牌滑动库，因为个人在项目中多次用到，而别人写的总是不能满足我的要求，因此自己写一个。已单独封装成一个库，见`YHDragCardContainer`


# 
