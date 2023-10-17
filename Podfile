# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
target 'Galaxy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'NSObject+Rx'

  pod 'Alamofire'
  pod 'Moya'
  
  pod 'SwiftyJSON'

  pod 'CocoaLumberjack/Swift'
  
  pod 'SnapKit'
  
  pod 'MBProgressHUD'
  
  pod 'FLEX'
  
  pod 'BigInt'
  pod 'CryptoSwift'
#  pod 'secp256k1_gl_ios'
  pod 'secp256k1.c'
  
  #pod 'web3swift', :git => 'https://github.com/liujunliuhong/web3swift.git'
  # Pods for Galaxy

  target 'GalaxyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GalaxyUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
