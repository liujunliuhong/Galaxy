//
//  Date+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base == Date {
    /// 是否是今天
    public var isToday: Bool {
        let calendar = Calendar(identifier: Calendar.current.identifier)
        let cmps: Set<Calendar.Component> = [.year, .month, .day]
        let current = calendar.dateComponents(cmps, from: base)
        let now = calendar.dateComponents(cmps, from: Date())
        return current.year == now.year && current.month == now.month && current.day == now.day
    }
    
    /// 获取星座
    ///
    ///     水瓶座 1月20日-------2月18日
    ///     双鱼座 2月19日-------3月20日
    ///     白羊座 3月21日-------4月19日
    ///     金牛座 4月20日-------5月20日
    ///     双子座 5月21日-------6月21日
    ///     巨蟹座 6月22日-------7月22日
    ///     狮子座 7月23日-------8月22日
    ///     处女座 8月23日-------9月22日
    ///     天秤座 9月23日------10月23日
    ///     天蝎座 10月24日-----11月21日
    ///     射手座 11月22日-----12月21日
    ///     摩羯座 12月22日------1月19日
    public var constellation: ConstellationType? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        let resultString = dateFormatter.string(from: base)
        guard let doubleResult = Double(resultString) else { return nil }
        let factor: Double = pow(10.0, 2.0) // 100
        let value = (doubleResult * factor).rounded(.up) / factor
        switch value {
        case 1.20...2.18 :      return .aquarius     // 水瓶座
        case 2.19...3.20 :      return .pisces       // 双鱼座
        case 3.21...4.19 :      return .aries        // 白羊座
        case 4.20...5.20 :      return .taurus       // 金牛座
        case 5.21...6.21 :      return .gemini       // 双子座
        case 6.22...7.22 :      return .cancer       // 巨蟹座
        case 7.23...8.22 :      return .leo          // 狮子座
        case 8.23...9.22 :      return .virgo        // 处女座
        case 9.23...10.23 :     return .libra        // 天秤座
        case 10.24...11.22 :    return .scorpio      // 天蝎座
        case 11.23...12.21 :    return .sagittarius  // 射手座
        case 12.22...12.31 :    return .capricorn    // 摩羯座
        case 1.01...1.19 :      return .capricorn    // 摩羯座
        default:                return nil
        }
    }
}
