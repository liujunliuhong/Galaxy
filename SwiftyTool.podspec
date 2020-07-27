
Pod::Spec.new do |s|
  s.name                       = 'SwiftyTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '1.0.1'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '9.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'SwiftyTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '9.0'
  s.requires_arc               = true
  s.static_framework = true
  
  # File
  s.subspec 'File' do |ss|
    ss.source_files = 'Sources/File/*'
  end

  # Words Sort
  s.subspec 'WordsSort' do |ss|
    ss.source_files = 'Sources/Words Sort/*'
  end


  # Permission
  s.subspec 'Permission' do |ss|
    ss.source_files = 'Sources/Permission/*'
  end

  # Log
  s.subspec 'Log' do |ss|
    ss.source_files = 'Sources/Log/*'
    ss.dependency 'CocoaLumberjack/Swift'
  end

  # HUD
  s.subspec 'HUD' do |ss|
    ss.source_files = 'Sources/HUD/*'
    ss.dependency 'MBProgressHUD'
    ss.resource = 'Sources/HUD/SwiftyHUD.bundle'
  end

  # UIKit
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'Sources/UIKit/*'
  end

  # Foundation
  s.subspec 'Foundation' do |ss|
    ss.source_files = 'Sources/Foundation/*'
  end

  # NavigationBar
  s.subspec 'NavigationBar' do |ss|
    ss.source_files = 'Sources/NavigationBar/*'
    ss.dependency 'SnapKit'
    ss.dependency 'SwiftyTool/UIKit'
  end



  # Texture
  s.subspec 'AsyncDisplayKit' do |ss|
    ss.source_files = 'Sources/AsyncDisplayKit/*'
    ss.dependency 'Texture'
  end


  # System Face
  s.subspec 'SystemFace' do |ss|
    ss.source_files = 'Sources/System Face/*'
    ss.resource = 'Sources/System Face/YHSystemFace.bundle'
  end

  # SystemImagePicker
  s.subspec 'SystemImagePicker' do |ss|
    ss.source_files = 'Sources/SystemImagePicker/*'
  end

  # Tag
  s.subspec 'Tag' do |ss|
    ss.source_files = 'Sources/Tag/*'
  end

  # ViewModelType
  s.subspec 'ViewModelType' do |ss|
    ss.source_files = 'Sources/ViewModelType/*'
  end

  # TabBarController
  s.subspec 'TabBarController' do |ss|
    ss.source_files = 'Sources/SwiftyTabBarController/*'
  end

  # TencentUpload
  s.subspec 'TencentUpload' do |ss|
    ss.source_files = 'Sources/TencentUpload/*'
    ss.dependency 'QCloudCOSXML'
  end

  
  # NativeLocation
  s.subspec 'NativeLocation' do |ss|
    ss.source_files = 'Sources/NativeLocation/*'
  end


  # BaiduLocation
  s.subspec 'BaiduLocation' do |ss|
    ss.source_files = 'Sources/BaiduLocation/*'
    ss.dependency 'BMKLocationKit'
  end

  # GaoDeLocation
  s.subspec 'GaoDeLocation' do |ss|
    ss.source_files = 'Sources/GaoDeLocation/*'
    ss.dependency 'AMapLocation'
  end

  # Picker
  s.subspec 'Picker' do |ss|
    ss.source_files = 'Sources/Picker/*'
  end

  # City Picker
  s.subspec 'CityPicker' do |ss|
    ss.source_files = 'Sources/City Picker/*'
    ss.resource = 'Sources/City Picker/SwiftyCity.bundle'
    ss.dependency 'SwiftyTool/Picker'
    ss.dependency 'SwiftyJSON'
  end

end
