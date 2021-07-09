//
//  UIColor+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base == UIColor {
    /// 白色
    public static let white: UIColor = GL.rgba(R: 255, G: 255, B: 255)
    
    /// 黑色
    public static let black: UIColor = GL.rgba(R: 0, G: 0, B: 0)
    
    /// 透明
    public static let clear: UIColor = GL.black.withAlphaComponent(0)
    
    /// `R`、`G`、`B`、`A`转`UIColor`
    public static func rgba(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) -> UIColor {
        return UIColor(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: A)
    }
    
    /// 获取一个随机颜色
    public static func randomColor() -> UIColor {
        let R: CGFloat = Int.random(in: Range(uncheckedBounds: (0, 255))).gl.cgFloat
        let G: CGFloat = Int.random(in: Range(uncheckedBounds: (0, 255))).gl.cgFloat
        let B: CGFloat = Int.random(in: Range(uncheckedBounds: (0, 255))).gl.cgFloat
        let A: CGFloat = 1.0
        return GL.rgba(R: R, G: G, B: B, A: A)
    }
    
    /// `16`进制转颜色
    ///
    /// 形如`0xFFFFFF`、`0xffffff`
    public static func hexColor(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((Double((hex >> 16) & 0xFF)) / 255.0)
        let green = CGFloat((Double((hex >> 8) & 0xFF)) / 255.0)
        let blue = CGFloat((Double(hex & 0xFF)) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 字符串转颜色
    ///
    /// 支持`#ffffff`、`#FFFFFF`、 `#fff`、 `255, 255, 255`、 `255,255,255`、 `0xFFFFFF`
    public static func color(string: String?) -> UIColor {
        guard var string = string else { return GL.clear }
        
        string = string.uppercased()
        string = string.replacingOccurrences(of: "#", with: "")
        string = string.replacingOccurrences(of: "0X", with: "")
        string = string.replacingOccurrences(of: " ", with: "")
        
        // "255,255,255"
        if let rgbColor = _rgb_string_color(string: string) {
            return rgbColor
        }
        
        var hexColor: UIColor? = nil
        // hex
        switch string.count {
            case 3: // RGB    #fff
                let alpha: CGFloat = 1.0
                let red = _color(string: string, start: 0, length: 1)
                let green = _color(string: string, start: 1, length: 1)
                let blue = _color(string: string, start: 2, length: 1)
                hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            case 4: // ARGB   #ffff
                let alpha = _color(string: string, start: 0, length: 1)
                let red = _color(string: string, start: 1, length: 1)
                let green = _color(string: string, start: 2, length: 1)
                let blue = _color(string: string, start: 3, length: 1)
                hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            case 6: // RRGGBB  #ffffff
                let alpha: CGFloat = 1.0
                let red = _color(string: string, start: 0, length: 2)
                let green = _color(string: string, start: 2, length: 2)
                let blue = _color(string: string, start: 4, length: 2)
                hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            case 8: // AARRGGBB  #ffffffff
                let alpha = _color(string: string, start: 0, length: 2)
                let red = _color(string: string, start: 2, length: 2)
                let green = _color(string: string, start: 4, length: 2)
                let blue = _color(string: string, start: 6, length: 2)
                hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            default:
                break
        }
        return hexColor ?? GL.clear
    }
}

extension GL where Base == UIColor {
    /// 颜色转图片
    public func toImage(size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        base.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        return UIImage(cgImage: aCgImage)
    }
}


private func _rgb_string_color(string: String) -> UIColor? {
    if !string.contains(",") {
        return nil
    }
    var alpha: CGFloat = 1.0
    var red: CGFloat = .zero
    var green: CGFloat = .zero
    var blue: CGFloat = .zero
    
    let splits = string.split(separator: ",")
    let colorStrings = splits.compactMap{ "\($0)" }
    
    if colorStrings.count == 3 {
        red = CGFloat(Int(colorStrings[0]) ?? 0) / 255.0
        green = CGFloat(Int(colorStrings[1]) ?? 0) / 255.0
        blue = CGFloat(Int(colorStrings[2]) ?? 0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    } else if colorStrings.count == 4 {
        red = CGFloat(Int(colorStrings[0]) ?? 0) / 255.0
        green = CGFloat(Int(colorStrings[1]) ?? 0) / 255.0
        blue = CGFloat(Int(colorStrings[2]) ?? 0) / 255.0
        alpha = CGFloat(Double(colorStrings[3]) ?? 1.0) // default 1.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    return nil
}

private func _color(string: String, start: Int, length: Int) -> CGFloat {
    if start > string.count {
        return .zero
    }
    if start + length > string.count {
        return .zero
    }
    let string = string
    let startIndex = string.index(string.startIndex, offsetBy: start)
    let endIndex = string.index(startIndex, offsetBy: length)
    var subString = String(string[startIndex..<endIndex])
    if subString.count < 1 || subString.count > 2 {
        return .zero
    }
    if subString.count == 1 {
        subString += subString
    }
    var value: UInt32 = 0
    let scanner = Scanner(string: subString)
    scanner.scanHexInt32(&value)
    return CGFloat(value) / 255.0
}

