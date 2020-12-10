
Pod::Spec.new do |s|
  s.name                       = 'SwiftyTool'
  s.homepage                   = 'https://github.com/liujunliuhong/SwiftTool'
  s.summary                    = 'Swift版本的开发工具'
  s.description                = 'Swift版本的开发工具，旨在帮助开发人员快速开发，持续更新中...'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '1.1.65'
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

  # Chain
  s.subspec 'Chain' do |ss|
    ss.source_files = 'Sources/Chain/*.swift'
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

  # Navigation
  s.subspec 'Navigation' do |ss|
    ss.source_files = 'Sources/Navigation/*.swift'
  end

  # Notification
  s.subspec 'Notification' do |ss|
    ss.source_files = 'Sources/Notification/*.swift'
  end

  # Crypto
  s.subspec 'Crypto' do |ss|
    ss.source_files = 'Sources/Crypto/*.swift'
  end

  # AttributedString
  s.subspec 'AttributedString' do |ss|
    ss.source_files = 'Sources/AttributedString/*.swift'
  end

  # Location
  s.subspec 'Location' do |ss|
    # Single
    ss.subspec 'Single' do |sss|
      sss.source_files = 'Sources/Location/Single/*.swift'
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
    # Online
    ss.subspec 'Online' do |sss|
      sss.source_files = 'Sources/Dating/Online/*.swift'
    end
    # Error
    ss.subspec 'Error' do |sss|
      sss.source_files = 'Sources/Dating/Error/*.swift'
    end
    # Local Push
    ss.subspec 'LocalPush' do |sss|
      sss.source_files = 'Sources/Dating/LocalPush/*.swift'
    end
    # RobotMessage
    ss.subspec 'RobotMessage' do |sss|
      sss.source_files = 'Sources/Dating/RobotMessage/*.swift'
    end
    # Web
    ss.subspec 'Web' do |sss|
      sss.source_files = 'Sources/Dating/Web/*.swift'
      sss.dependency 'SnapKit'
      sss.dependency 'RxSwift'
      sss.dependency 'RxCocoa'
      sss.dependency 'NSObject+Rx'
      sss.resource = 'Sources/Dating/Web/GLDatingWeb.bundle'
    end
    # Photo
    ss.subspec 'Photo' do |sss|
      sss.source_files = 'Sources/Dating/Photo/*.swift'
      sss.dependency 'SwiftyTool/File'
    end
    # TermLabel
    ss.subspec 'TermLabel' do |sss|
      sss.source_files = 'Sources/Dating/TermLabel/*.swift'
      sss.dependency 'YYText'
    end
    # Sex
    ss.subspec 'Sex' do |sss|
      sss.source_files = 'Sources/Dating/Sex/*.swift'
      sss.dependency 'GRDB.swift'
    end
    # Message
    ss.subspec 'Message' do |sss|
      sss.source_files = 'Sources/Dating/Message/*.swift'
      sss.dependency 'GRDB.swift'
    end
    # TextField
    ss.subspec 'TextField' do |sss|
      sss.source_files = 'Sources/Dating/TextField/*.swift'
      sss.dependency 'RxSwift'
      sss.dependency 'RxCocoa'
      sss.dependency 'NSObject+Rx'
      sss.dependency 'SwiftyTool/UIKit'
    end
    # User
    ss.subspec 'User' do |sss|
      sss.source_files = 'Sources/Dating/User/*.swift'
      sss.dependency 'GRDB.swift'
      sss.dependency 'RxSwift'
      sss.dependency 'RxCocoa'
      sss.dependency 'SwiftyTool/Dating/Sex'
      sss.dependency 'SwiftyTool/Dating/Error'
      sss.dependency 'SwiftyTool/Foundation'
    end
    # Likes
    ss.subspec 'Likes' do |sss|
      sss.source_files = 'Sources/Dating/Likes/*.swift'
      sss.dependency 'GRDB.swift'
      sss.dependency 'SwiftyTool/Dating/Error'
    end

  end
  
end