//
//  SwiftyWordsSort.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public struct SwiftyWordsSortResult<T: NSObject> {
    public let key: String
    public let models: [T]
    init(key: String, models: [T]) {
        self.key = key
        self.models = models
    }
}

fileprivate extension String {
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            } // Chinese character range：0x4e00 ~ 0x9fff
        }
        return false
    }
}

public class SwiftyWordsSort<T: NSObject> {
    
    /// sepecial title, default `#`
    public var specialTitle: String = "#"
    
    /// special title insert at first, default `true`
    public var specialTitleInsertAtFirst: Bool = true
    
    /// extra polyphonic map
    public var extraPolyphonicMap: [String: String] = [:] {
        didSet {
            for (_, map) in extraPolyphonicMap.enumerated() {
                self.polyphonicMap[map.key] = map.value
            }
        }
    }
    
    
    
    
    private lazy var polyphonicMap: [String: String] = {
        return ["长安": "CA",
                "厦门": "XM",
                "曾经": "CJ",
                "重庆": "CQ",
                "长城": "CC",
                "地球": "DQ",
                "朝阳": "ZY",
                "犍为": "QW"]
    }()
    
    init() {
        
    }
}

extension SwiftyWordsSort {
    
}

extension SwiftyWordsSort {
    
    /// get first english words
    /// - Parameter string: string
    /// - Returns: string
    public static func getFirstEnglishWords(string: String) -> String {
        let string = string.uppercased()
        var result: String = ""
        for ch in string {
            let subString = String(ch)
            if subString.isIncludeChinese() {
                let ocString = subString as NSString
                if ocString.length > 0 {
                    let ch: unichar = ocString.character(at: 0)
                    let letter = NSString(format: "%c", yh_get_chinese_first_letters(ch)) as String
                    result.append(letter)
                } else {
                    result.append(subString)
                }
            } else {
                result.append(subString)
            }
        }
        return result.uppercased()
    }
    
    
    /// models sort
    /// - Parameters:
    ///   - models: models
    ///   - keyPath: keyPath
    ///   - closure: closure
    /// - Returns: none
    public func sort(models: [T], keyPath: String, closure: (([SwiftyWordsSortResult<T>]) -> ())?) {
        DispatchQueue.global().async {
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
                DispatchQueue.main.async {
                    closure?([])
                }
                return
            }
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            //
            var sortResult: [String: [T]] = [:]
            var specialModels: [T] = []
            for (_, model) in models.enumerated() {
                guard var value = model.value(forKeyPath: keyPath) as? String else {
                    continue
                }
                value = (value as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                
                var englishFirstLetters: String = SwiftyWordsSort.getFirstEnglishWords(string: value)
                if self.polyphonicMap.keys.contains(value) {
                    englishFirstLetters = self.polyphonicMap[value]!
                }
                print("\(englishFirstLetters)")
                
                guard let firstCharacter = englishFirstLetters.first else {
                    continue
                }
                
                let firstCharacterString: String = String(firstCharacter).uppercased()
                
                let min: Character = "A"
                let max: Character = "Z"
                
                if firstCharacter >= min && firstCharacter <= max {
                    if sortResult.keys.contains(firstCharacterString) {
                        var values = sortResult[firstCharacterString]!
                        values.append(model)
                        sortResult[firstCharacterString] = values
                    } else {
                        sortResult[firstCharacterString] = [model]
                    }
                } else {
                    specialModels.append(model)
                }
            }
            
            let newKeys: [String] = sortResult.keys.sorted { (s1, s2) -> Bool in
                return s1 <= s2
            }
            
            var results: [SwiftyWordsSortResult<T>] = []
            newKeys.forEach { (key) in
                let tmpModels = sortResult[key]!
                let m = SwiftyWordsSortResult<T>(key: key, models: tmpModels)
                results.append(m)
            }
            
            let specialResultModel = SwiftyWordsSortResult<T>(key: self.specialTitle, models: specialModels)
            
            if self.specialTitleInsertAtFirst {
                results.insert(specialResultModel, at: 0)
            } else {
                results.append(specialResultModel)
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            
            #if DEBUG
            print("sort total cost \(endTime - startTime)s")
            #endif
            
            DispatchQueue.main.async {
                closure?(results)
            }
        }
    }
}
