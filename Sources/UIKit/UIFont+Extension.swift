//
//  UIFont+Extension.swift
//  Galaxy
//
//  Created by liujun on 2021/7/9.
//

import Foundation
import UIKit

extension GL where Base == UIFont {
    public static func regular(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Regular"
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize:size, weight:.regular)
    }
    public static func semibold(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Semibold"
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize:size, weight:.semibold)
    }
    public static func light(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Light"
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize:size, weight:.light)
    }
    public static func medium(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Medium"
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize:size, weight:.medium)
    }
}
