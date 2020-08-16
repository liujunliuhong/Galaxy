//
//  UIColor+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 galaxy. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    /// RGBA -> UIColor
    /// - Parameters:
    ///   - R: R
    ///   - G: G
    ///   - B: B
    ///   - A: A
    /// - Returns: UIColor
    static func YH_RGBA(R: Int, G: Int, B: Int, A: CGFloat = 1) -> UIColor {
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
    
    /// Random Color
    static var YH_RandomColor: UIColor {
        let R: CGFloat = CGFloat(arc4random() % 255)
        let G: CGFloat = CGFloat(arc4random() % 255)
        let B: CGFloat = CGFloat(arc4random() % 255)
        let A: CGFloat = 1.0
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
    
    /// Hex -> UIColor
    /// - Parameters:
    ///   - hex: hex. 0xFFFFFF，0xffffff
    ///   - alpha: alpha
    /// - Returns: UIColor
    static func YH_HexColor(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((Double((hex >> 16) & 0xFF)) / 255.0)
        let green = CGFloat((Double((hex >> 8) & 0xFF)) / 255.0)
        let blue = CGFloat((Double(hex & 0xFF)) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// String -> UIColor
    /// - Parameter string: string.  "#ffffff"，"#FFFFFF", "#fff", "255, 255, 255"
    /// - Returns: UIColor
    static func YH_Color(string: String?) -> UIColor? {
        guard var string = string else { return nil }
        
        string = string.uppercased()
        string = string.replacingOccurrences(of: "#", with: "")
        string = string.replacingOccurrences(of: "0X", with: "")
        string = string.replacingOccurrences(of: " ", with: "")
        
        // "255, 255, 255"
        if let rgbColor = YH_RGB_StringColor(string: string) {
            return rgbColor
        }
        
        var hexColor: UIColor? = nil
        // hex
        switch string.count {
        case 3: // RGB    #fff
            let alpha: CGFloat = 1.0
            let red = UIColor.color(string: string, start: 0, length: 1)
            let green = UIColor.color(string: string, start: 1, length: 1)
            let blue = UIColor.color(string: string, start: 2, length: 1)
            hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        case 4: // ARGB   #ffff
            let alpha = UIColor.color(string: string, start: 0, length: 1)
            let red = UIColor.color(string: string, start: 1, length: 1)
            let green = UIColor.color(string: string, start: 2, length: 1)
            let blue = UIColor.color(string: string, start: 3, length: 1)
            hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        case 6: // RRGGBB  #ffffff
            let alpha: CGFloat = 1.0
            let red = UIColor.color(string: string, start: 0, length: 2)
            let green = UIColor.color(string: string, start: 2, length: 2)
            let blue = UIColor.color(string: string, start: 4, length: 2)
            hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        case 8: // AARRGGBB  #ffffffff
            let alpha = UIColor.color(string: string, start: 0, length: 2)
            let red = UIColor.color(string: string, start: 2, length: 2)
            let green = UIColor.color(string: string, start: 4, length: 2)
            let blue = UIColor.color(string: string, start: 6, length: 2)
            hexColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        default:
            break
        }
        
        return hexColor
    }
    
    /// RGB String -> Color.   "255,255,255"   "255,255,255,1"
    /// - Parameter string: string
    /// - Returns: UIColor
    static func YH_RGB_StringColor(string: String) -> UIColor? {
        var color: UIColor? = nil
        if string.contains(",") {
            var alpha: CGFloat = 1.0
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            
            let splits = string.split(separator: ",")
            let colorStrings = splits.compactMap{ "\($0)" }
            
            if colorStrings.count == 3 {
                red = CGFloat(Int(colorStrings[0]) ?? 0) / 255.0
                green = CGFloat(Int(colorStrings[1]) ?? 0) / 255.0
                blue = CGFloat(Int(colorStrings[2]) ?? 0) / 255.0
                color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            } else if colorStrings.count == 4 {
                red = CGFloat(Int(colorStrings[0]) ?? 0) / 255.0
                green = CGFloat(Int(colorStrings[1]) ?? 0) / 255.0
                blue = CGFloat(Int(colorStrings[2]) ?? 0) / 255.0
                alpha = CGFloat(Double(colorStrings[3]) ?? 1.0) // default 1.0
                color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }
        return color
    }
}

fileprivate extension UIColor {
    static func color(string: String, start: Int, length: Int) -> CGFloat {
        if start > string.count {
            return 0.0
        }
        if start + length > string.count {
            return 0.0
        }
        
        let string = string
        
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(startIndex, offsetBy: length)
        
        var subString = String(string[startIndex..<endIndex])
        
        if subString.count < 1 || subString.count > 2 {
            return .zero
        }
        
        if subString.count == 1 {
            subString = subString + subString
        }
        
        var value: UInt32 = 0
        
        let scanner = Scanner(string: subString)
        scanner.scanHexInt32(&value)
        
        return CGFloat(value) / 255.0
    }
}
