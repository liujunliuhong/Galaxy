//
//  UIDevice+TypeExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

/*
 iPhone 14            390 x 844             3x
 iPhone 14 Plus       428 x 926             3x
 iPhone 14 Pro        393 x 852             3x
 iPhone 14 Pro Max    430 x 932             3x
 
 iPhone SE 3rd        375 x 667             2x
 
 iPhone 13 Pro Max    428 x 926             3x
 iPhone 13 Pro        390 x 844             3x
 iPhone 13            390 x 844             3x
 iPhone 13 mini       360 x 780             3x
 
 iPhone 12 Pro Max    428 x 926             3x
 iPhone 12 Pro        390 x 844             3x
 iPhone 12            390 x 844             3x
 iPhone 12 mini       360 x 780             3x
 
 iPhone SE 2nd        375 x 667             2x
 
 iPhone 11            414 x 896             2x
 iPhone 11 Pro        375 x 812             3x
 iPhone 11 Pro Max    414 x 896             3x
 
 iPhone XR            414 x 896             2x
 iPhone Xs Max        414 x 896             3x
 iPhone Xs            375 x 812             3x
 iPhone X             375 x 812             3x
 
 iPhone 8             375 x 667             2x
 iPhone 8 Plus        414 x 736             3x
 
 iPhone 7             375 x 667             2x
 iPhone 7 plus        414 x 736             3x
 
 iPhone 6             375 x 667             2x
 iPhone 6s            375 x 667             2x  (UI design drawings are generally based on 6s, if not, then hammer him)
 iPhone 6 Plus        414 x 736             3x
 iPhone 6s plus       414 x 736             3x
 
 iPhone SE            320 x 568             2x
 
 iPhone 5             320 x 568             2x
 iPhone 5s            320 x 568             2x
 */
extension GL where Base == UIDevice {
    /// https://www.theiphonewiki.com/wiki/Models#iPhone
    public enum DeviceType: CaseIterable, Equatable {
        // AirPods
        case AirPods_1st_generation
        case AirPods_2nd_generation
        case AirPods_3rd_generation
        case AirPods_Pro
        case AirPods_Pro_2nd_generation
        case AirPods_Max
        // Apple TV
        case Apple_TV_1st_generation
        case Apple_TV_2nd_generation
        case Apple_TV_3rd_generation
        case Apple_TV_4th_generation
        case Apple_TV_4K
        case Apple_TV_4K_2nd_generation
        // Apple Watch
        case Apple_Watch_1st_generation
        case Apple_Watch_Series_1
        case Apple_Watch_Series_2
        case Apple_Watch_Series_3
        case Apple_Watch_Series_4
        case Apple_Watch_Series_5
        case Apple_Watch_SE
        case Apple_Watch_Series_6
        case Apple_Watch_Series_7
        case Apple_Watch_SE_2nd_generation
        case Apple_Watch_Series_8
        case Apple_Watch_Ultra
        // HomePod
        case HomePod
        case HomePod_mini
        // iPad
        case iPad
        case iPad_2
        case iPad_3rd_generation
        case iPad_4th_generation
        case iPad_5th_generation
        case iPad_6th_generation
        case iPad_7th_generation
        case iPad_8th_generation
        case iPad_9th_generation
        case iPad_10th_generation
        // iPad Air
        case iPad_Air
        case iPad_Air_2
        case iPad_Air_3rd_generation
        case iPad_Air_4th_generation
        case iPad_Air_5th_generation
        // iPad Pro
        case iPad_Pro_12_9_inch
        case iPad_Pro_9_7_inch
        case iPad_Pro_12_9_inch_2nd_generation
        case iPad_Pro_10_5_inch
        case iPad_Pro_11_inch
        case iPad_Pro_12_9_inch_3rd_generation
        case iPad_Pro_11_inch_2nd_generation
        case iPad_Pro_12_9_inch_4th_generation
        case iPad_Pro_11_inch_3nd_generation
        case iPad_Pro_12_9_inch_5th_generation
        // iPad mini
        case iPad_mini
        case iPad_mini_2
        case iPad_mini_3
        case iPad_mini_4
        case iPad_mini_5th_generation
        case iPad_mini_6th_generation
        // iPod touch
        case iPod_touch
        case iPod_touch_2nd_generation
        case iPod_touch_3rd_generation
        case iPod_touch_4th_generation
        case iPod_touch_5th_generation
        case iPod_touch_6th_generation
        case iPod_touch_7th_generation
        // AirTag
        case AirTag
        // iPhone
        case iPhone
        case iPhone_3G
        case iPhone_3GS
        case iPhone_4
        case iPhone_4s
        case iPhone_5
        case iPhone_5c
        case iPhone_5s
        case iPhone_6
        case iPhone_6_Plus
        case iPhone_6s
        case iPhone_6s_Plus
        case iPhone_SE_1st_generation
        case iPhone_7
        case iPhone_7_Plus
        case iPhone_8
        case iPhone_8_Plus
        case iPhone_X
        case iPhone_XR
        case iPhone_XS
        case iPhone_XS_Max
        case iPhone_11
        case iPhone_11_Pro
        case iPhone_11_Pro_Max
        case iPhone_SE_2nd_generation
        case iPhone_12_mini
        case iPhone_12
        case iPhone_12_Pro
        case iPhone_12_Pro_Max
        case iPhone_13_mini
        case iPhone_13
        case iPhone_13_Pro
        case iPhone_13_Pro_Max
        case iPhone_SE_3rd_generation
        case iPhone_14
        case iPhone_14_Plus
        case iPhone_14_Pro
        case iPhone_14_Pro_Max
        // iMac
        case iMac_24_inch_M1_2021
        // Mac mini
        case Mac_mini_M1_2020
        // MacBook Air
        case MacBook_Air_Late_2020
        // MacBook Pro
        case MacBook_Pro_13_inch_M1_2020
        case MacBook_Pro_14_inch_2021
        case MacBook_Pro_16_inch_2021
        // Simulator
        case simulator
    }
}

extension GalaxyWrapper.DeviceType: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.description
    }
    
    public var description: String {
        switch self {
                // AirPods
            case .AirPods_1st_generation:                return "AirPods (1st generation)"
            case .AirPods_2nd_generation:                return "AirPods (2nd generation)"
            case .AirPods_3rd_generation:                return "AirPods (3rd generation)"
            case .AirPods_Pro:                           return "AirPods Pro"
            case .AirPods_Pro_2nd_generation:            return "AirPods Pro (2nd generation)"
            case .AirPods_Max:                           return "AirPods Max"
                // Apple TV
            case .Apple_TV_1st_generation:               return "Apple TV (1st generation)"
            case .Apple_TV_2nd_generation:               return "Apple TV (2nd generation)"
            case .Apple_TV_3rd_generation:               return "Apple TV (3rd generation)"
            case .Apple_TV_4th_generation:               return "Apple TV (4th generation)"
            case .Apple_TV_4K:                           return "Apple TV 4K"
            case .Apple_TV_4K_2nd_generation:            return "Apple TV 4K (2nd generation)"
                // Apple Watch
            case .Apple_Watch_1st_generation:            return "Apple Watch (1st generation)"
            case .Apple_Watch_Series_1:                  return "Apple Watch Series 1"
            case .Apple_Watch_Series_2:                  return "Apple Watch Series 2"
            case .Apple_Watch_Series_3:                  return "Apple Watch Series 3"
            case .Apple_Watch_Series_4:                  return "Apple Watch Series 4"
            case .Apple_Watch_Series_5:                  return "Apple Watch Series 5"
            case .Apple_Watch_SE:                        return "Apple Watch SE"
            case .Apple_Watch_Series_6:                  return "Apple Watch Series 6"
            case .Apple_Watch_Series_7:                  return "Apple Watch Series 7"
            case .Apple_Watch_SE_2nd_generation:         return "Apple Watch SE (2nd generation)"
            case .Apple_Watch_Series_8:                  return "Apple Watch Series 8"
            case .Apple_Watch_Ultra:                     return "Apple Watch Ultra"
                // HomePod
            case .HomePod:                               return "HomePod"
            case .HomePod_mini:                          return "HomePod mini"
                // iPad
            case .iPad:                                  return "iPad"
            case .iPad_2:                                return "iPad 2"
            case .iPad_3rd_generation:                   return "iPad (3rd generation)"
            case .iPad_4th_generation:                   return "iPad (4th generation)"
            case .iPad_5th_generation:                   return "iPad (5th generation)"
            case .iPad_6th_generation:                   return "iPad (6th generation)"
            case .iPad_7th_generation:                   return "iPad (7th generation)"
            case .iPad_8th_generation:                   return "iPad (8th generation)"
            case .iPad_9th_generation:                   return "iPad (9th generation)"
            case .iPad_10th_generation:                  return "iPad (10th generation)"
                // iPad Air
            case .iPad_Air:                              return "iPad Air"
            case .iPad_Air_2:                            return "iPad Air 2"
            case .iPad_Air_3rd_generation:               return "iPad Air (3rd generation)"
            case .iPad_Air_4th_generation:               return "iPad Air (4th generation)"
            case .iPad_Air_5th_generation:               return "iPad Air (5th generation)"
                // iPad Pro
            case .iPad_Pro_12_9_inch:                    return "iPad Pro (12.9-inch)"
            case .iPad_Pro_9_7_inch:                     return "iPad Pro (9.7-inch)"
            case .iPad_Pro_12_9_inch_2nd_generation:     return "iPad Pro (12.9-inch) (2nd generation)"
            case .iPad_Pro_10_5_inch:                    return "iPad Pro (10.5-inch)"
            case .iPad_Pro_11_inch:                      return "iPad Pro (11-inch)"
            case .iPad_Pro_12_9_inch_3rd_generation:     return "iPad Pro (12.9-inch) (3rd generation)"
            case .iPad_Pro_11_inch_2nd_generation:       return "iPad Pro (11-inch) (2nd generation)"
            case .iPad_Pro_12_9_inch_4th_generation:     return "iPad Pro (12.9-inch) (4th generation)"
            case .iPad_Pro_11_inch_3nd_generation:       return "iPad Pro (11-inch) (3rd generation)"
            case .iPad_Pro_12_9_inch_5th_generation:     return "iPad Pro (12.9-inch) (5th generation)"
                // iPad mini
            case .iPad_mini:                             return "iPad mini"
            case .iPad_mini_2:                           return "iPad mini 2"
            case .iPad_mini_3:                           return "iPad mini 3"
            case .iPad_mini_4:                           return "iPad mini 4"
            case .iPad_mini_5th_generation:              return "iPad mini (5th generation)"
            case .iPad_mini_6th_generation:              return "iPad mini (6th generation)"
                // iPod touch
            case .iPod_touch:                            return "iPod touch"
            case .iPod_touch_2nd_generation:             return "iPod touch (2nd generation)"
            case .iPod_touch_3rd_generation:             return "iPod touch (3rd generation)"
            case .iPod_touch_4th_generation:             return "iPod touch (4th generation)"
            case .iPod_touch_5th_generation:             return "iPod touch (5th generation)"
            case .iPod_touch_6th_generation:             return "iPod touch (6th generation)"
            case .iPod_touch_7th_generation:             return "iPod touch (7th generation)"
                // AirTag
            case .AirTag:                                return "AirTag"
                // iPhone
            case .iPhone:                                return "iPhone"
            case .iPhone_3G:                             return "iPhone 3G"
            case .iPhone_3GS:                            return "iPhone 3GS"
            case .iPhone_4:                              return "iPhone 4"
            case .iPhone_4s:                             return "iPhone 4S"
            case .iPhone_5:                              return "iPhone 5"
            case .iPhone_5c:                             return "iPhone 5c"
            case .iPhone_5s:                             return "iPhone 5s"
            case .iPhone_6:                              return "iPhone 6"
            case .iPhone_6_Plus:                         return "iPhone 6 Plus"
            case .iPhone_6s:                             return "iPhone 6s"
            case .iPhone_6s_Plus:                        return "iPhone 6s Plus"
            case .iPhone_SE_1st_generation:              return "iPhone SE (1st generation)"
            case .iPhone_7:                              return "iPhone 7"
            case .iPhone_7_Plus:                         return "iPhone 7 Plus"
            case .iPhone_8:                              return "iPhone 8"
            case .iPhone_8_Plus:                         return "iPhone 8 Plus"
            case .iPhone_X:                              return "iPhone X"
            case .iPhone_XR:                             return "iPhone XR"
            case .iPhone_XS:                             return "iPhone XS"
            case .iPhone_XS_Max:                         return "iPhone XS Max"
            case .iPhone_11:                             return "iPhone 11"
            case .iPhone_11_Pro:                         return "iPhone 11 Pro"
            case .iPhone_11_Pro_Max:                     return "iPhone 11 Pro Max"
            case .iPhone_SE_2nd_generation:              return "iPhone SE (2nd generation)"
            case .iPhone_12_mini:                        return "iPhone 12 mini"
            case .iPhone_12:                             return "iPhone 12"
            case .iPhone_12_Pro:                         return "iPhone 12 Pro"
            case .iPhone_12_Pro_Max:                     return "iPhone 12 Pro Max"
            case .iPhone_13_mini:                        return "iPhone 13 mini"
            case .iPhone_13:                             return "iPhone 13"
            case .iPhone_13_Pro:                         return "iPhone 13 Pro"
            case .iPhone_13_Pro_Max:                     return "iPhone 13 Pro Max"
            case .iPhone_SE_3rd_generation:              return "iPhone SE (3rd generation)"
            case .iPhone_14:                             return "iPhone 14"
            case .iPhone_14_Plus:                        return "iPhone 14 Plus"
            case .iPhone_14_Pro:                         return "iPhone 14 Pro"
            case .iPhone_14_Pro_Max:                     return "iPhone 14 Pro Max"
                // iMac
            case .iMac_24_inch_M1_2021:                  return "iMac (24-inch, M1, 2021)"
                // MacBook Air
            case .Mac_mini_M1_2020:                      return "Mac mini (M1, 2020)"
            case .MacBook_Air_Late_2020:                 return "MacBook Air (Late 2020)"
                // MacBook Pro
            case .MacBook_Pro_13_inch_M1_2020:           return "MacBook Pro (13-inch, M1, 2020)"
            case .MacBook_Pro_14_inch_2021:              return "MacBook Pro (14-inch, 2021)"
            case .MacBook_Pro_16_inch_2021:              return "MacBook Pro (16-inch, 2021)"
                // Simulator
            case .simulator:                             return "Simulator"
        }
    }
    
    public var identifiers: [String] {
        switch self {
                // AirPods
            case .AirPods_1st_generation:                return ["AirPods1,1"]
            case .AirPods_2nd_generation:                return ["AirPods1,2", "AirPods2,1"]
            case .AirPods_3rd_generation:                return ["AirPods1,3", "Audio2,1"]
            case .AirPods_Pro:                           return ["iProd8,1", "AirPods2,2", "AirPodsPro1,1"]
            case .AirPods_Pro_2nd_generation:            return ["AirPodsPro1,2"]
            case .AirPods_Max:                           return ["iProd8,6", "AirPodsMax1,1"]
                // Apple TV
            case .Apple_TV_1st_generation:               return ["AppleTV1,1"]
            case .Apple_TV_2nd_generation:               return ["AppleTV2,1"]
            case .Apple_TV_3rd_generation:               return ["AppleTV3,1", "AppleTV3,2"]
            case .Apple_TV_4th_generation:               return ["AppleTV5,3"]
            case .Apple_TV_4K:                           return ["AppleTV6,2"]
            case .Apple_TV_4K_2nd_generation:            return ["AppleTV11,1"]
                // Apple Watch
            case .Apple_Watch_1st_generation:            return ["Watch1,1", "Watch1,2"]
            case .Apple_Watch_Series_1:                  return ["Watch2,6", "Watch2,7"]
            case .Apple_Watch_Series_2:                  return ["Watch2,3", "Watch2,4"]
            case .Apple_Watch_Series_3:                  return ["Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4"]
            case .Apple_Watch_Series_4:                  return ["Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4"]
            case .Apple_Watch_Series_5:                  return ["Watch5,1", "Watch5,2", "Watch5,3", "Watch5,4"]
            case .Apple_Watch_SE:                        return ["Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12"]
            case .Apple_Watch_Series_6:                  return ["Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4"]
            case .Apple_Watch_Series_7:                  return ["Watch6,6", "Watch6,7", "Watch6,8", "Watch6,9"]
            case .Apple_Watch_SE_2nd_generation:         return ["Watch6,10", "Watch6,11", "Watch6,12", "Watch6,13"]
            case .Apple_Watch_Series_8:                  return ["Watch6,14", "Watch6,15", "Watch6,16", "Watch6,17"]
            case .Apple_Watch_Ultra:                     return ["Watch6,18"]
                // HomePod
            case .HomePod:                               return ["AudioAccessory1,1", "AudioAccessory1,2"]
            case .HomePod_mini:                          return ["AudioAccessory5,1"]
                // iPad
            case .iPad:                                  return ["iPad1,1"]
            case .iPad_2:                                return ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"]
            case .iPad_3rd_generation:                   return ["iPad3,1", "iPad3,2", "iPad3,3"]
            case .iPad_4th_generation:                   return ["iPad3,4", "iPad3,5", "iPad3,6"]
            case .iPad_5th_generation:                   return ["iPad6,11", "iPad6,12"]
            case .iPad_6th_generation:                   return ["iPad7,5", "iPad7,6"]
            case .iPad_7th_generation:                   return ["iPad7,11", "iPad7,12"]
            case .iPad_8th_generation:                   return ["iPad11,6", "iPad11,7"]
            case .iPad_9th_generation:                   return ["iPad12,1", "iPad12,2"]
            case .iPad_10th_generation:                  return ["iPad13,18", "iPad13,19"]
                // iPad Air
            case .iPad_Air:                              return ["iPad4,1", "iPad4,2", "iPad4,3"]
            case .iPad_Air_2:                            return ["iPad5,3", "iPad5,4"]
            case .iPad_Air_3rd_generation:               return ["iPad11,3", "iPad11,4"]
            case .iPad_Air_4th_generation:               return ["iPad13,1", "iPad13,2"]
            case .iPad_Air_5th_generation:               return ["iPad13,16", "iPad13,17"]
                // iPad Pro
            case .iPad_Pro_12_9_inch:                    return ["iPad6,7", "iPad6,8"]
            case .iPad_Pro_9_7_inch:                     return ["iPad6,3", "iPad6,4"]
            case .iPad_Pro_12_9_inch_2nd_generation:     return ["iPad7,1", "iPad7,2"]
            case .iPad_Pro_10_5_inch:                    return ["iPad7,3", "iPad7,4"]
            case .iPad_Pro_11_inch:                      return ["iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"]
            case .iPad_Pro_12_9_inch_3rd_generation:     return ["iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"]
            case .iPad_Pro_11_inch_2nd_generation:       return ["iPad8,9", "iPad8,10"]
            case .iPad_Pro_12_9_inch_4th_generation:     return ["iPad8,11", "iPad8,12"]
            case .iPad_Pro_11_inch_3nd_generation:       return ["iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7"]
            case .iPad_Pro_12_9_inch_5th_generation:     return ["iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11"]
                // iPad mini
            case .iPad_mini:                             return ["iPad2,5", "iPad2,6", "iPad2,7"]
            case .iPad_mini_2:                           return ["iPad4,4", "iPad4,5", "iPad4,6"]
            case .iPad_mini_3:                           return ["iPad4,7", "iPad4,8", "iPad4,9"]
            case .iPad_mini_4:                           return ["iPad5,1", "iPad5,2"]
            case .iPad_mini_5th_generation:              return ["iPad11,1", "iPad11,2"]
            case .iPad_mini_6th_generation:              return ["iPad14,1", "iPad14,2"]
                // iPod touch
            case .iPod_touch:                            return ["iPod1,1"]
            case .iPod_touch_2nd_generation:             return ["iPod2,1"]
            case .iPod_touch_3rd_generation:             return ["iPod3,1"]
            case .iPod_touch_4th_generation:             return ["iPod4,1"]
            case .iPod_touch_5th_generation:             return ["iPod5,1"]
            case .iPod_touch_6th_generation:             return ["iPod7,1"]
            case .iPod_touch_7th_generation:             return ["iPod9,1"]
                // AirTag
            case .AirTag:                                return ["AirTag1,1"]
                // iPhone
            case .iPhone:                                return ["iPhone1,1"]
            case .iPhone_3G:                             return ["iPhone1,2"]
            case .iPhone_3GS:                            return ["iPhone2,1"]
            case .iPhone_4:                              return ["iPhone3,1", "iPhone3,2", "iPhone3,3"]
            case .iPhone_4s:                             return ["iPhone4,1"]
            case .iPhone_5:                              return ["iPhone5,1", "iPhone5,2"]
            case .iPhone_5c:                             return ["iPhone5,3", "iPhone5,4"]
            case .iPhone_5s:                             return ["iPhone6,1", "iPhone6,2"]
            case .iPhone_6:                              return ["iPhone7,2"]
            case .iPhone_6_Plus:                         return ["iPhone7,1"]
            case .iPhone_6s:                             return ["iPhone8,1"]
            case .iPhone_6s_Plus:                        return ["iPhone8,2"]
            case .iPhone_SE_1st_generation:              return ["iPhone8,4"]
            case .iPhone_7:                              return ["iPhone9,1", "iPhone9,3"]
            case .iPhone_7_Plus:                         return ["iPhone9,2", "iPhone9,4"]
            case .iPhone_8:                              return ["iPhone10,1", "iPhone10,4"]
            case .iPhone_8_Plus:                         return ["iPhone10,2", "iPhone10,5"]
            case .iPhone_X:                              return ["iPhone10,3", "iPhone10,6"]
            case .iPhone_XR:                             return ["iPhone11,8"]
            case .iPhone_XS:                             return ["iPhone11,2"]
            case .iPhone_XS_Max:                         return ["iPhone11,6", "iPhone11,4"]
            case .iPhone_11:                             return ["iPhone12,1"]
            case .iPhone_11_Pro:                         return ["iPhone12,3"]
            case .iPhone_11_Pro_Max:                     return ["iPhone12,5"]
            case .iPhone_SE_2nd_generation:              return ["iPhone12,8"]
            case .iPhone_12_mini:                        return ["iPhone13,1"]
            case .iPhone_12:                             return ["iPhone13,2"]
            case .iPhone_12_Pro:                         return ["iPhone13,3"]
            case .iPhone_12_Pro_Max:                     return ["iPhone13,4"]
            case .iPhone_13_mini:                        return ["iPhone14,4"]
            case .iPhone_13:                             return ["iPhone14,5"]
            case .iPhone_13_Pro:                         return ["iPhone14,2"]
            case .iPhone_13_Pro_Max:                     return ["iPhone14,3"]
            case .iPhone_SE_3rd_generation:              return ["iPhone14,6"]
            case .iPhone_14:                             return ["iPhone14,7"]
            case .iPhone_14_Plus:                        return ["iPhone14,8"]
            case .iPhone_14_Pro:                         return ["iPhone15,2"]
            case .iPhone_14_Pro_Max:                     return ["iPhone15,3"]
                // iMac
            case .iMac_24_inch_M1_2021:                  return ["iMac21,1", "iMac21,2"]
                // Mac mini
            case .Mac_mini_M1_2020:                      return ["Macmini9,1"]
                // MacBook Air
            case .MacBook_Air_Late_2020:                 return ["MacBookAir10,1"]
                // MacBook Pro
            case .MacBook_Pro_13_inch_M1_2020:           return ["MacBookPro17,1"]
            case .MacBook_Pro_14_inch_2021:              return ["MacBookPro18,3", "MacBookPro18,4"]
            case .MacBook_Pro_16_inch_2021:              return ["MacBookPro18,1", "MacBookPro18,2"]
                // Simulator
            case .simulator:                             return ["i386", "x86_64"]
        }
    }
}
