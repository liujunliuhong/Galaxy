
Pod::Spec.new do |s|
  s.name                       = 'SwiftyTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '2.0.0'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '10.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'SwiftyTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '10.0'
  s.requires_arc               = true
  s.static_framework           = true
  s.source_files               = 'Sources/*/*.swift','Sources/*/*.{h,m}'
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'SnapKit'
  s.dependency 'Alamofire'
  s.dependency 'BigInt'
  s.dependency 'CryptoSwift'
end