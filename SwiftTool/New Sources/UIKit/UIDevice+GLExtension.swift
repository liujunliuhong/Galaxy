//
//  UIDevice+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/17.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public var GL_SCREEN_WIDTH: CGFloat {
    return UIScreen.main.bounds.size.width
}

public var GL_SCREEN_HEIGHT: CGFloat {
    return UIScreen.main.bounds.size.height
}


public enum GLDeviceInfoType {
    case description(identifiers: [String], deviceType: GLDeviceType, name: String)
}


public enum GLDeviceType {
    // iPhone
    case iPhone_12_Pro_Max
    case iPhone_12_Pro
    case iPhone_12
    case iPhone_12_mini
    case iPhone_SE_2nd
    case iPhoneX_S_Max
    case iPhoneXS
    case iPhoneXR
    case iPhoneX
    case iPhone_11
    case iPhone_11_Pro
    case iPhone_11_Pro_Max
    case iPhone_8_Plus
    case iPhone_8
    case iPhone_7_Plus
    case iPhone_7
    case iPhone_SE
    case iPhone_6s_Plus
    case iPhone_6s
    case iPhone_6_Plus
    case iPhone_6
    case iPhone_5s
    case iPhone_5c
    case iPhone_5
    case iPhone_4s
    case iPhone_4
    case iPhone_3GS
    case iPhone_3G
    case iPhone
    // iPod touch
    case iPod_touch_7th_generation
    case iPod_touch_6th_generation
    case iPod_touch_5th_generation
    case iPod_touch_4th_generation
    case iPod_touch_3rd_generation
    case iPod_touch_2nd_generation
    case iPod_touch_1st_generation
    // iPad
    case iPad
    case iPad_2
    case iPad_3rd_generation
    case iPad_4th_generation
    case iPad_5th_generation
    case iPad_6th_generation
    case iPad_7th_generation
    case iPad_8th_generation
    // iPad Air
    case iPad_Air
    case iPad_Air_2
    case iPad_Air_3rd_generation
    case iPad_Air_4th_generation
    // iPad Pro
    case iPad_Pro_9_7_inch
    case iPad_Pro_10_5_inch
    case iPad_Pro_11_inch
    case iPad_Pro_11_inch_2nd_generation
    case iPad_Pro_12_9_inch
    case iPad_Pro_12_9_inch_2nd_generation
    case iPad_Pro_12_9_inch_3rd_generation
    case iPad_Pro_12_9_inch_4th_generation
    // iPad mini
    case iPad_mini
    case iPad_mini_2
    case iPad_mini_3
    case iPad_mini_4
    case iPad_mini_5th_generation
    // AirPods
    case AirPods_1st_generation
    case AirPods_2nd_generation
    case AirPods_Pro
    // Apple TV
    case Apple_TV_1st_generation
    case Apple_TV_2nd_generation
    case Apple_TV_3rd_generation
    case Apple_TV_4th_generation
    case Apple_TV_4K
    // Apple Watch
    case Apple_Watch_1st_generation
    case Apple_Watch_Series_1
    case Apple_Watch_Series_2
    case Apple_Watch_Series_3
    case Apple_Watch_Series_4
    case Apple_Watch_Series_5
    case Apple_Watch_SE
    case Apple_Watch_Series_6
    // HomePod
    case HomePod
    // Simulator
    case simulator
}

// Example: https://www.theiphonewiki.com/wiki/Models#iPhone
public let GLDeviceMachines: [GLDeviceInfoType] = [
    // AirPods
    .description(identifiers: ["AirPods1,1"], deviceType: .AirPods_1st_generation, name: "AirPods (1st generation)"),
    .description(identifiers: ["AirPods2,1"], deviceType: .AirPods_2nd_generation, name: "AirPods (2nd generation)"),
    .description(identifiers: ["iProd8,1"], deviceType: .AirPods_Pro, name: "AirPods Pro"),
    // Apple TV
    .description(identifiers: ["AppleTV1,1"], deviceType: .Apple_TV_1st_generation, name: "Apple TV (1st generation)"),
    .description(identifiers: ["AppleTV2,1"], deviceType: .Apple_TV_2nd_generation, name: "Apple TV (2nd generation)"),
    .description(identifiers: ["AppleTV3,1"], deviceType: .Apple_TV_3rd_generation, name: "Apple TV (3rd generation)"),
    .description(identifiers: ["AppleTV3,2"], deviceType: .Apple_TV_3rd_generation, name: "Apple TV (3rd generation)"),
    .description(identifiers: ["AppleTV5,3"], deviceType: .Apple_TV_4th_generation, name: "Apple TV (4th generation)"),
    .description(identifiers: ["AppleTV6,2"], deviceType: .Apple_TV_4K, name: "Apple TV 4K"),
    // Apple Watch
    .description(identifiers: ["Watch1,1", "Watch1,2"], deviceType: .Apple_Watch_1st_generation, name: "Apple Watch (1st generation)"),
    .description(identifiers: ["Watch2,6", "Watch2,7"], deviceType: .Apple_Watch_Series_1, name: "Apple Watch Series 1"),
    .description(identifiers: ["Watch2,3", "Watch2,4"], deviceType: .Apple_Watch_Series_2, name: "Apple Watch Series 2"),
    .description(identifiers: ["Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4"], deviceType: .Apple_Watch_Series_3, name: "Apple Watch Series 3"),
    .description(identifiers: ["Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4"], deviceType: .Apple_Watch_Series_4, name: "Apple Watch Series 4"),
    .description(identifiers: ["Watch5,1", "Watch5,2", "Watch5,3", "Watch5,4"], deviceType: .Apple_Watch_Series_5, name: "Apple Watch Series 5"),
    .description(identifiers: ["Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12"], deviceType: .Apple_Watch_SE, name: "Apple Watch SE"),
    .description(identifiers: ["Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4"], deviceType: .Apple_Watch_Series_6, name: "Apple Watch Series 6"),
    // HomePod
    .description(identifiers: ["AudioAccessory1,1", "AudioAccessory1,2"], deviceType: .HomePod, name: "HomePod")
    // iPad
]

public let GLMachineMap: [String: GLDeviceMachineType] = [
    // iPhone
    "iPhone1,1"            :          .iPhone,
    "iPhone1,2"            :          .iPhone_3G,
    "iPhone2,1"            :          .iPhone_3GS,
    "iPhone3,1"            :          .iPhone_4,
    "iPhone3,2"            :          .iPhone_4,
    "iPhone3,3"            :          .iPhone_4,
    "iPhone4,1"            :          .iPhone_4s,
    "iPhone5,1"            :          .iPhone_5,
    "iPhone5,2"            :          .iPhone_5,
    "iPhone5,3"            :          .iPhone_5c,
    "iPhone5,4"            :          .iPhone_5c,
    "iPhone6,1"            :          .iPhone_5s,
    "iPhone6,2"            :          .iPhone_5s,
    "iPhone7,2"            :          .iPhone_6,
    "iPhone7,1"            :          .iPhone_6_Plus,
    "iPhone8,1"            :          .iPhone_6s,
    "iPhone8,2"            :          .iPhone_6s_Plus,
    "iPhone8,4"            :          .iPhone_SE,
    "iPhone9,1"            :          .iPhone_7,
    "iPhone9,3"            :          .iPhone_7,
    "iPhone9,2"            :          .iPhone_7_Plus,
    "iPhone9,4"            :          .iPhone_7_Plus,
    "iPhone10,1"           :          .iPhone_8,
    "iPhone10,4"           :          .iPhone_8,
    "iPhone10,2"           :          .iPhone_8_Plus,
    "iPhone10,5"           :          .iPhone_8_Plus,
    "iPhone10,3"           :          .iPhoneX,
    "iPhone10,6"           :          .iPhoneX,
    "iPhone11,8"           :          .iPhoneXR,
    "iPhone11,2"           :          .iPhoneXS,
    "iPhone11,6"           :          .iPhoneX_S_Max,
    "iPhone12,1"           :          .iPhone_11,
    "iPhone12,3"           :          .iPhone_11_Pro,
    "iPhone12,5"           :          .iPhone_11_Pro_Max,
    "iPhone12,8"           :          .iPhone_SE_2nd,
    "iPhone13,1"           :          .iPhone_12_mini,
    "iPhone13,2"           :          .iPhone_12,
    "iPhone13,3"           :          .iPhone_12_Pro,
    "iPhone13,4"           :          .iPhone_12_Pro_Max,
    // iPod touch
    "iPod1,1"              :          .iPod_touch_1st_generation,
    "iPod2,1"              :          .iPod_touch_2nd_generation,
    "iPod3,1"              :          .iPod_touch_3rd_generation,
    "iPod4,1"              :          .iPod_touch_4th_generation,
    "iPod5,1"              :          .iPod_touch_5th_generation,
    "iPod7,1"              :          .iPod_touch_6th_generation,
    "iPod9,1"              :          .iPod_touch_7th_generation,
    // iPad
    "iPad1,1"              :          .iPad,
    "iPad2,1"              :          .iPad_2,
    "iPad2,2"              :          .iPad_2,
    "iPad2,3"              :          .iPad_2,
    "iPad2,4"              :          .iPad_2,
    "iPad3,1"              :          .iPad_3rd_generation,
    "iPad3,2"              :          .iPad_3rd_generation,
    "iPad3,3"              :          .iPad_3rd_generation,
    "iPad3,4"              :          .iPad_4th_generation,
    "iPad3,5"              :          .iPad_4th_generation,
    "iPad3,6"              :          .iPad_4th_generation,
    "iPad4,1"              :          .iPad_Air,
    "iPad4,2"              :          .iPad_Air,
    "iPad4,3"              :          .iPad_Air,
    "iPad5,3"              :          .iPad_Air_2,
    "iPad5,4"              :          .iPad_Air_2,
    "iPad6,7"              :          .iPad_Pro_12_9_inch,
    "iPad6,8"              :          .iPad_Pro_12_9_inch,
    "iPad6,3"              :          .iPad_Pro_9_7_inch,
    "iPad6,4"              :          .iPad_Pro_9_7_inch,
    "iPad6,11"             :          .iPad_5th_generation,
    "iPad6,12"             :          .iPad_5th_generation,
    "iPad7,1"              :          .iPad_Pro_12_9_inch_2nd_generation,
    "iPad7,2"              :          .iPad_Pro_12_9_inch_2nd_generation,
    "iPad7,3"              :          .iPad_Pro_10_5_inch,
    "iPad7,4"              :          .iPad_Pro_10_5_inch,
    "iPad7,5"              :          .iPad_6th_generation,
    "iPad7,6"              :          .iPad_6th_generation,
    "iPad8,1"              :          .iPad_Pro_11_inch,
    "iPad8,2"              :          .iPad_Pro_11_inch,
    "iPad8,3"              :          .iPad_Pro_11_inch,
    "iPad8,4"              :          .iPad_Pro_11_inch,
    "iPad8,5"              :          .iPad_Pro_12_9_inch_3rd_generation,
    "iPad8,6"              :          .iPad_Pro_12_9_inch_3rd_generation,
    "iPad8,7"              :          .iPad_Pro_12_9_inch_3rd_generation,
    "iPad8,8"              :          .iPad_Pro_12_9_inch_3rd_generation,
    "iPad11,3"             :          .iPad_Air_3rd_generation,
    "iPad11,4"             :          .iPad_Air_3rd_generation,
    // iPad mini
    "iPad2,5"              :          .iPad_mini,
    "iPad2,6"              :          .iPad_mini,
    "iPad2,7"              :          .iPad_mini,
    "iPad4,4"              :          .iPad_mini_2,
    "iPad4,5"              :          .iPad_mini_2,
    "iPad4,6"              :          .iPad_mini_2,
    "iPad4,7"              :          .iPad_mini_3,
    "iPad4,8"              :          .iPad_mini_3,
    "iPad4,9"              :          .iPad_mini_3,
    "iPad5,1"              :          .iPad_mini_4,
    "iPad5,2"              :          .iPad_mini_4,
    "iPad11,1"             :          .iPad_mini_5th_generation,
    "iPad11,2"             :          .iPad_mini_5th_generation,
    // AirPods
    "AirPods1,1"           :          .AirPods_1st_generation,
    "AirPods2,1"           :          .AirPods_2nd_generation,
    // Apple TV
    "AppleTV2,1"           :          .Apple_TV_2nd_generation,
    "AppleTV3,1"           :          .Apple_TV_3rd_generation,
    "AppleTV3,2"           :          .Apple_TV_3rd_generation,
    "AppleTV5,3"           :          .Apple_TV_4th_generation,
    "AppleTV6,2"           :          .Apple_TV_4K,
    // Apple Watch
    "Watch1,1"             :          .Apple_Watch_1st_generation,
    "Watch1,2"             :          .Apple_Watch_1st_generation,
    "Watch2,6"             :          .Apple_Watch_Series_1,
    "Watch2,7"             :          .Apple_Watch_Series_1,
    "Watch2,3"             :          .Apple_Watch_Series_2,
    "Watch2,4"             :          .Apple_Watch_Series_2,
    "Watch3,1"             :          .Apple_Watch_Series_3,
    "Watch3,2"             :          .Apple_Watch_Series_3,
    "Watch3,3"             :          .Apple_Watch_Series_3,
    "Watch3,4"             :          .Apple_Watch_Series_3,
    "Watch4,1"             :          .Apple_Watch_Series_4,
    "Watch4,2"             :          .Apple_Watch_Series_4,
    "Watch4,3"             :          .Apple_Watch_Series_4,
    "Watch4,4"             :          .Apple_Watch_Series_4,
    // HomePod
    "AudioAccessory1,1"    :          .HomePod,
    "AudioAccessory1,2"    :          .HomePod,
    // Simulator
    "i386"                 :          .simulator,
    "x86_64"               :          .simulator
]

/*
 iPhone SE 2nd:       375 x 667             2x
 
 iPhone 11:           414 x 896             2x
 iPhone 11 Pro:       375 x 812             3x
 iPhone 11 Pro Max:   414 x 896             3x
 
 iPhone XR:           414 x 896             2x
 iPhone Xs Max:       414 x 896             3x
 iPhone Xs:           375 x 812             3x
 iPhone X:            375 x 812             3x
 
 iPhone 8:            375 x 667             2x
 iPhone 8 Plus:       414 x 736             3x
 
 iPhone 7:            375 x 667             2x
 iPhone 7 plus:       414 x 736             3x
 
 iPhone 6:            375 x 667             2x
 iPhone 6s:           375 x 667             2x  (UI design drawings are generally based on 6s, if not, then hammer him)
 iPhone 6 Plus:       414 x 736             3x
 iPhone 6s plus:      414 x 736             3x
 
 iPhone SE:           320 x 568             2x
 
 iPhone 5:            320 x 568             2x
 iPhone 5s:           320 x 568             2x
 */
extension UIDevice {
    
    // such as `iPhone 7 Plus`.
    public static var gl_machineName: String {
        let machine = UIDevice.YHMachine
        if let map = UIDevice.YHMachineMap[machine] {
            return map.rawValue
        } else {
            return "Unknown Identifier: \(machine)"
        }
    }
    
    // Get Base Device Info.
    static func GL_BasicDeviceInfo() -> String {
        let info = "*****************************************************************************************************************\nSysname:          \(UIDevice.YHSysname)\nRelease:          \(UIDevice.YHRelease)\nVersion:          \(UIDevice.YHVersion)\nMachine:          \(UIDevice.YHMachine)\nSystemVersion:    \(UIDevice.current.systemVersion)\nMachineName:      \(UIDevice.YHMachineName)\n*****************************************************************************************************************"
        return info
    }
    
    
    /// Whether it is a bangs screen phone (compatible with all iPhones)
    static var gl_is_Fringe: Bool {
        let machine = UIDevice.YHMachine
        guard let map = UIDevice.YHMachineMap[machine] else { return false }
        var result: Bool = false
        if map == .iPhoneX ||
            map == .iPhoneXR ||
            map == .iPhoneXS ||
            map == .iPhoneX_S_Max ||
            map == .iPhone_11 ||
            map == .iPhone_11_Pro ||
            map == .iPhone_11_Pro_Max {
            result = true
        } else {
            if UIDevice.GLSimulatorIsiPhoneX {
                result = true
            }
        }
        return result
    }
    
    /// Liu Hai height (in fact, the height of StatusBar, compatible with all iPhones)
    static var GLFringe_Height: CGFloat {
        let machine = UIDevice.YHMachine
        guard let map = UIDevice.YHMachineMap[machine] else { return .zero }
        var value: CGFloat = .zero
        if map == .iPhoneX ||
            map == .iPhoneXR ||
            map == .iPhoneXS ||
            map == .iPhoneX_S_Max ||
            map == .iPhone_11 ||
            map == .iPhone_11_Pro ||
            map == .iPhone_11_Pro_Max {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                value = 0.0
            } else {
                value = 44.0
            }
        } else {
            if UIDevice.GLSimulatorIsiPhoneX {
                if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                    value = 0.0
                } else {
                    value = 44.0
                }
            } else {
                value = 20.0
            }
        }
        return value
    }
    
    
    /// Is there a virtual Home button (compatible with all iPhones)
    static var GLIs_HomeIndicator: Bool {
        let machine = UIDevice.YHMachine
        guard let map = UIDevice.YHMachineMap[machine] else { return false }
        var result: Bool = false
        if map == .iPhoneX ||
            map == .iPhoneXR ||
            map == .iPhoneXS ||
            map == .iPhoneX_S_Max ||
            map == .iPhone_11 ||
            map == .iPhone_11_Pro ||
            map == .iPhone_11_Pro_Max {
            result = true
        } else {
            if UIDevice.GLSimulatorIsiPhoneX {
                result = true
            }
        }
        return result
    }
    
    
    /// Virtual Home button height (compatible with all iPhones)
    static var GLHomeIndicator_Height: CGFloat {
        let machine = UIDevice.YHMachine
        guard let map = UIDevice.YHMachineMap[machine] else { return .zero }
        var value: CGFloat = .zero
        if map == .iPhoneX
            || map == .iPhoneXR
            || map == .iPhoneXS
            || map == .iPhoneX_S_Max
            || map == .iPhone_11
            || map == .iPhone_11_Pro
            || map == .iPhone_11_Pro_Max {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                value = 21.0
            } else {
                value = 34.0
            }
        } else {
            if map == .simulator {
                if UIDevice.GLSimulatorIsiPhoneX {
                    if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                        value = 21.0
                    } else {
                        value = 34.0
                    }
                }
            }
        }
        return value
    }
    
    /// Is the simulator iPhone X
    static var GLSimulatorIsiPhoneX: Bool {
        let machine = UIDevice.YHMachine
        guard let map = UIDevice.YHMachineMap[machine] else { return false }
        if map != .simulator {
            return false
        }
        var result: Bool = false
        let width = GLWidth
        let height = GLHeight
        if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown {
            if (width == 375.0 && height == 812.0) || (width == 414.0 && height == 896.0) {
                result = true
            }
        } else {
            if (width == 812.0 && height == 375.0) || (width == 896.0 && height == 414.0) {
                result = true
            }
        }
        return result
    }
}



public extension UIDevice {
    
    
    
}

extension UIDevice {
    private static var _sys: utsname {
        var sys: utsname = utsname()
        uname(&sys)
        return sys
    }
    
    private static var _machine: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var _release: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var _version: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var _sysname: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var _nodename: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
}
