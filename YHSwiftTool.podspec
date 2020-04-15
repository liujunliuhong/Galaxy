
Pod::Spec.new do |s|
  s.name                       = 'YHSwiftTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '0.0.9'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '9.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'YHSwiftTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '9.0'
  s.requires_arc               = true
  s.static_framework = true
  
  


  # Core
  s.subspec 'Core' do |ss|
    ss.source_files            = 'Sources/*', 'Sources/AsyncDisplayKit/*', 'Sources/Foundation/*', 'Sources/Location/*.swift', 'Sources/NavigationBar/*', 'Sources/NetworkRequest/*', 'Sources/Other/*', 'Sources/Picker/*', 'Sources/RxErrorTracker/*', 'Sources/System Face/*', 'Sources/Tag/*', 'Sources/UIImagePicker/*', 'Sources/UIKit/*', 'Sources/ViewModelType/*', 'Sources/YHTabBarController/*'
  ss.resource                  = 'Sources/System Face/YHSystemFace.bundle'
  ss.dependency 'RxSwift'
  ss.dependency 'RxCocoa'
  ss.dependency 'NSObject+Rx'
  ss.dependency 'Alamofire'
  ss.dependency 'SwiftyJSON'
  ss.dependency 'Result'
  ss.dependency 'CocoaLumberjack/Swift'
  ss.dependency 'MBProgressHUD'
  ss.dependency 'SnapKit'
  ss.dependency 'Texture'
  end

  # 腾讯云存储
  s.subspec 'TencentUpload' do |ss|
    ss.source_files = 'Sources/QCloudCOS/YHQCloudCOSManager.swift'
    ss.dependency 'QCloudCOSXML'
  end

  # 百度定位
  s.subspec 'BaiDuLocation' do |ss|
    ss.source_files = 'Sources/Location/*.{h,m}'
    ss.dependency 'BMKLocationKit'
  end

end
