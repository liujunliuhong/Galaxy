//
//  UIDevice+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/8/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension UIDevice {
    public static var YH_Width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public static var YH_Height: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    // Get machine name, such as `iPhone 7 Plus`.
    public static var YHMachineName: String {
        let machine = UIDevice.YHMachine
        
        if let map = UIDevice.YHMachineMap[machine] {
            return map.rawValue
        } else {
            return "Unknown Identifier: \(machine)"
        }
    }
    
    // Print Device Info.
    public static func YHPrintBasicDeviceInfo() {
        YHDebugLog("\n*****************************************************************************************************************\nSysname:          \(UIDevice.YHSysname)\nRelease:          \(UIDevice.YHRelease)\nVersion:          \(UIDevice.YHVersion)\nMachine:          \(UIDevice.YHMachine)\nSystemVersion:    \(UIDevice.current.systemVersion)\nMachineName:      \(UIDevice.YHMachineName)\n*****************************************************************************************************************")
    }
    
    public static var YH_Is_iPhoneX: Bool {
        let machine = UIDevice.YHMachine
        if let map = UIDevice.YHMachineMap[machine] {
            return map == .iPhoneX || map == .iPhoneXR || map == .iPhoneXS || map == .iPhoneX_S_Max
        } else {
            return false
        }
    }
}


// Example:https://www.theiphonewiki.com/wiki/Models#iPhone
extension UIDevice {
    public enum YHDeviceMachineType: String {
        // iPhone
        case iPhoneX_S_Max                                              = "iPhone XS Max"
        case iPhoneXS                                                   = "iPhone XS"
        case iPhoneXR                                                   = "iPhone XR"
        case iPhoneX                                                    = "iPhone X"
        
        case iPhone_8_Plus                                              = "iPhone 8 Plus"
        case iPhone_8                                                   = "iPhone 8"
        case iPhone_7_Plus                                              = "iPhone 7 Plus"
        case iPhone_7                                                   = "iPhone 7"
        case iPhone_SE                                                  = "iPhone SE"
        case iPhone_6s_Plus                                             = "iPhone 6s Plus"
        case iPhone_6s                                                  = "iPhone 6s"
        case iPhone_6_Plus                                              = "iPhone 6 Plus"
        case iPhone_6                                                   = "iPhone 6"
        case iPhone_5s                                                  = "iPhone 5s"
        case iPhone_5c                                                  = "iPhone 5c"
        case iPhone_5                                                   = "iPhone 5"
        case iPhone_4s                                                  = "iPhone 4s"
        case iPhone_4                                                   = "iPhone 4"
        case iPhone_3GS                                                 = "iPhone 3GS"
        case iPhone_3G                                                  = "iPhone 3G"
        case iPhone                                                     = "iPhone"
        // iPod touch
        case iPod_touch_7th_generation                                  = "iPod touch (7th generation)"
        case iPod_touch_6th_generation                                  = "iPod touch (6th generation)"
        case iPod_touch_5th_generation                                  = "iPod touch (5th generation)"
        case iPod_touch_4th_generation                                  = "iPod touch (4th generation)"
        case iPod_touch_3rd_generation                                  = "iPod touch (3rd generation)"
        case iPod_touch_2nd_generation                                  = "iPod touch (2nd generation)"
        case iPod_touch_1st_generation                                  = "iPod touch (1st generation)"
        // iPad
        case iPad                                                       = "iPad"
        case iPad_2                                                     = "iPad 2"
        case iPad_3rd_generation                                        = "iPad (3rd generation)"
        case iPad_4th_generation                                        = "iPad (4th generation)"
        case iPad_Air                                                   = "iPad Air"
        case iPad_Air_2                                                 = "iPad Air 2"
        case iPad_Pro_12_9_inch                                         = "iPad Pro (12.9-inch)"
        case iPad_Pro_9_7_inch                                          = "iPad Pro (9.7-inch)"
        case iPad_5th_generation                                        = "iPad (5th generation)"
        case iPad_Pro_12_9_inch_2nd_generation                          = "iPad Pro (12.9-inch) (2nd generation)"
        case iPad_Pro_10_5_inch                                         = "iPad Pro (10.5-inch)"
        case iPad_6th_generation                                        = "iPad (6th generation)"
        case iPad_Pro_11_inch                                           = "iPad Pro (11-inch)"
        case iPad_Pro_12_9_inch_3rd_generation                          = "iPad Pro (12.9-inch) (3rd generation)"
        case iPad_Air_3rd_generation                                    = "iPad Air (3rd generation)"
        // iPad mini
        case iPad_mini                                                  = "iPad mini"
        case iPad_mini_2                                                = "iPad mini 2"
        case iPad_mini_3                                                = "iPad mini 3"
        case iPad_mini_4                                                = "iPad mini 4"
        case iPad_mini_5th_generation                                   = "iPad mini (5th generation)"
        // AirPods
        case AirPods_1st_generation                                     = "AirPods (1st generation)"
        case AirPods_2nd_generation                                     = "AirPods (2nd generation)"
        // Apple TV
        case Apple_TV_2nd_generation                                    = "Apple TV (2nd generation)"
        case Apple_TV_3rd_generation                                    = "Apple TV (3rd generation)"
        case Apple_TV_4th_generation                                    = "Apple TV (4th generation)"
        case Apple_TV_4K                                                = "Apple TV 4K"
        // Apple Watch
        case Apple_Watch_1st_generation                                 = "Apple Watch (1st generation)"
        case Apple_Watch_Series_1                                       = "Apple Watch Series 1"
        case Apple_Watch_Series_2                                       = "Apple Watch Series 2"
        case Apple_Watch_Series_3                                       = "Apple Watch Series 3"
        case Apple_Watch_Series_4                                       = "Apple Watch Series 4"
        // HomePod
        case HomePod                                                    = "HomePod"
        // Simulator
        case simulator                                                  = "simulator"
    }
    
    public static var YHMachineMap: [String: YHDeviceMachineType] = [
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
}


extension UIDevice {
    private static var YHSys: utsname {
        var sys: utsname = utsname()
        uname(&sys)
        return sys
    }
    
    private static var YHMachine: String {
        var sys = UIDevice.YHSys
        return withUnsafePointer(to: &sys.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var YHRelease: String {
        var sys = UIDevice.YHSys
        return withUnsafePointer(to: &sys.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var YHVersion: String {
        var sys = UIDevice.YHSys
        return withUnsafePointer(to: &sys.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var YHSysname: String {
        var sys = UIDevice.YHSys
        return withUnsafePointer(to: &sys.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    private static var YHNodename: String {
        var sys = UIDevice.YHSys
        return withUnsafePointer(to: &sys.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
}
