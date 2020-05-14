//
//  SwiftyWordsSort.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

struct SwiftyWordsSort<T: NSObject> {
    
    init() {
        
    }
}

extension SwiftyWordsSort {
    public static func getEnglishFirstWords(string: String) -> String {
        let string = string.uppercased()
        var result: String = ""
        for ch in string.unicodeScalars {
            let letter: Int8 = yh_get_chinese_first_letters(UInt16(ch.value))
            if let r = UnicodeScalar(Int(letter)) {
                let w = Character(r)
                result.append(w)
            }
        }
        return result.uppercased()
    }
}

extension SwiftyWordsSort {
    public func sort(models: [T], keyPath: String) {
        
        // check
        var isContainKey: Bool = false
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(T.classForCoder(), &count) else { return }
        for i in 0..<count {
            let property = properties[Int(i)]
            let name = property_getName(property)
            if let propertyName = String(utf8String: name),
                propertyName == keyPath {
                isContainKey = true
                break
            }
        }
        if isContainKey == false {
            print("\(T.classForCoder()) not contain key:\(keyPath)")
            return
        }
        
        
        for (index, model) in models.enumerated() {
            if var value = model.value(forKeyPath: keyPath) as? String {
                value = (value as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                
            }
        }
        
        
        
        
    }
}
