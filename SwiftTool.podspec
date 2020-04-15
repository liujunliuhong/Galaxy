
Pod::Spec.new do |s|
  s.name                       = 'YHSwiftTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '0.0.1'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '9.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.source_files               = 'Sources/*','Sources/*/*'
  s.module_name                = 'YHSwiftTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '9.0'
  s.requires_arc               = true


  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'NSObject+Rx'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'Result'
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'MBProgressHUD'
  s.dependency 'SnapKit'
end
