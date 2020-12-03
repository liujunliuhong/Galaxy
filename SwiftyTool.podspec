
Pod::Spec.new do |s|
  s.name                       = 'SwiftyTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '1.1.62'
  s.source                     = { :git => 'https://github.com/liujunliuhong/SwiftTool.git', :tag => s.version.to_s }
  s.platform                   = :ios, '10.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'SwiftyTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '10.0'
  s.requires_arc               = true
  s.static_framework           = true
  

  # UIKit
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'Sources/UIKit/*.swift'
  end


 # Foundation
  s.subspec 'Foundation' do |ss|
    ss.source_files = 'Sources/Foundation/*.swift'
  end

  # File
  s.subspec 'File' do |ss|
    ss.source_files = 'Sources/File/*.swift'
  end


  # Log
  s.subspec 'Log' do |ss|
    ss.source_files = 'Sources/Log/*.swift'
    ss.dependency 'CocoaLumberjack/Swift'
  end


  # HUD
  s.subspec 'HUD' do |ss|
    ss.source_files = 'Sources/Hud/*.swift'
    ss.dependency 'MBProgressHUD'
    ss.dependency 'SwiftyTool/UIKit'
    ss.resource = 'Sources/Hud/GLHud.bundle'
  end


  # NavigationBar
  s.subspec 'NavigationBar' do |ss|
    ss.source_files = 'Sources/NavigationBar/*.swift'
    ss.dependency 'GLDeviceTool'
    ss.dependency 'SwiftyTool/UIKit'
    ss.dependency 'SnapKit'
  end


  # AsyncDisplayKit
  s.subspec 'AsyncDisplayKit' do |ss|
    ss.source_files = 'Sources/AsyncDisplayKit/*.swift'
    ss.dependency 'SwiftyTool/Foundation'
    ss.dependency 'SwiftyTool/UIKit'
    ss.dependency 'Texture'
  end


  # Map
  s.subspec 'Map' do |ss|
    ss.source_files = 'Sources/Map/*.swift'
    ss.dependency 'SwiftyTool/UIKit'
    ss.dependency 'SwiftyTool/Foundation'
  end


  # System Face Keyboard
  s.subspec 'SystemFaceKeyboard' do |ss|
    ss.source_files = 'Sources/SystemFaceKeyboard/*.swift'
    ss.dependency 'SwiftyTool/UIKit'
    ss.resource = 'Sources/SystemFaceKeyboard/GLSystemFace.bundle'
  end

  # Alert
  s.subspec 'Alert' do |ss|
    ss.source_files = 'Sources/Alert/*.swift'
    ss.dependency 'Texture'
    ss.dependency 'SnapKit'
  end


  # WeakProxy
  s.subspec 'WeakProxy' do |ss|
    ss.source_files = 'Sources/WeakProxy/*.{h,m}'
  end

  # Reachability
  s.subspec 'Reachability' do |ss|
    ss.source_files = 'Sources/Reachability/*.swift'
    ss.dependency 'Alamofire'
  end


  # WordsSort
  s.subspec 'WordsSort' do |ss|
    ss.source_files = 'Sources/WordsSort/*.swift'
  end

  # PickerView
  s.subspec 'PickerView' do |ss|
    # Common
    ss.subspec 'Common' do |sss|
      sss.source_files = 'Sources/PickerView/Picker/*.swift'
    end
    # City
    ss.subspec 'City' do |sss|
      sss.source_files = 'Sources/PickerView/City Picker/*.swift'
      sss.resource = 'Sources/PickerView/City Picker/GLCity.bundle'
      sss.dependency 'SwiftyTool/PickerView/Common'
    end
  end


  # Dating
  s.subspec 'Dating' do |ss|
    # MessageNotification
    ss.subspec 'MessageNotification' do |sss|
      sss.source_files = 'Sources/Dating/MessageNotification/*.swift'
      sss.dependency 'SwiftyTool/WeakProxy'
      sss.dependency 'SwiftyTool/Alert'
      sss.dependency 'SDWebImage'
    end
    # AudioPlay
    ss.subspec 'AudioPlay' do |sss|
      sss.source_files = 'Sources/Dating/AudioPlay/*.swift'
    end
    # AVPlayer
    ss.subspec 'AVPlayer' do |sss|
      sss.source_files = 'Sources/Dating/AVPlayer/*.swift'
    end
    
  end
  
end