
Pod::Spec.new do |s|
  s.name                       = 'GLBaiDuLocation'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '1.1.2'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '10.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'GLBaiDuLocation'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '9.0'
  s.requires_arc               = true
  s.static_framework           = true
  s.source_files               = 'BaiDuLocation/*.{h,m}'
  s.dependency                 = 'BMKLocationKit'
end
