# SwiftTool
Swift版本的开发工具，旨在帮助开发人员快速开发，未完，持续更新中...

## 由于经常更新，不支持pod，请手动导入
## 使用到的三方库:
```
pod 'Moya'
pod 'MBProgressHUD'
pod 'SnapKit'
```
## 请在自己项目的桥接文件里面引入`#import "YHSwiftTool_OC_Header.h"`
```
桥接文件设置:TARGETS -> Build Settings -> 搜索Swift Compiler -> 找到Objective-C bridging Header，然后就可以设置自己的桥接文件或者更改桥接文件名
```
