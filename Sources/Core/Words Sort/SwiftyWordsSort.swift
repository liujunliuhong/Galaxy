//
//  SwiftyWordsSort.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public struct SwiftyWordsSortResult<T> {
    public let key: String
    public let models: [T]
    init(key: String, models: [T]) {
        self.key = key
        self.models = models
    }
}

public class SwiftyWordsSort<T> {
    
    /// sepecial section title, default `#`
    public var specialSectionTitle: String = "#"
    
    /// special section title insert at first, default `true`
    public var specialSectionTitleInsertAtFirst: Bool = true
    
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
    
    /// get first english words
    /// - Parameter string: string
    /// - Returns: string
    public static func getFirstEnglishWords(string: String) -> String {
        let string = string.uppercased()
        var result: String = ""
        
        for scalar in string.unicodeScalars {
            if !String(scalar).isIncludeChinese() {
                result.append(String(scalar))
                continue
            }
            let code = Int(scalar.value)
            let index = code - 19968
            if index >= 0 && index < firstLetterArray.count {
                let s = firstLetterArray[index]
                result.append(s)
            } else {
                result.append(String(scalar))
            }
        }
        /*
        for scalar in string.unicodeScalars {
            let code = Int(scalar.value)
            if code >= 65 && code <= 90 {
                result.append(String(scalar))
            } else if code >= 97 && code <= 122 {
                result.append(String(scalar))
            } else {
                let index = code - 19968
                if index >= 0 && index < firstLetterArray.count {
                    let s = firstLetterArray[index]
                    result.append(s)
                } else {
                    result.append(String(scalar))
                }
            }
        }
        */
        return result.uppercased()
    }
    
    /// get full english words
    /// - Parameter string: string
    public static func getFullEnglishWords(string: String) -> String? {
        let str = NSMutableString(string: string) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                return str as String
            }
        }
        return nil
    }
    
    /// models sort
    /// - Parameters:
    ///   - models: models
    ///   - keyPath: keyPath
    ///   - closure: closure
    /// - Returns: none
    public func sort(models: [T], keyPath: String?, closure: (([SwiftyWordsSortResult<T>]) -> ())?) {
        DispatchQueue.global().async {
            // check
            if models.count <= 0 {
                #if DEBUG
                print("models is empty.")
                #endif
                DispatchQueue.main.async {
                    closure?([])
                }
                return
            }
            if let keyPath = keyPath {
                var isContainKey: Bool = false
                let firstModel = models.first!
                let mirror = Mirror(reflecting: firstModel)
                for (label, _) in mirror.children {
                    if let label = label, label == keyPath {
                        isContainKey = true
                        break
                    }
                }
                if isContainKey == false {
                    #if DEBUG
                    print("\(T.self) not contain key:\(keyPath).")
                    #endif
                    DispatchQueue.main.async {
                        closure?([])
                    }
                    return
                }
            }
            
            //
            let startTime = CFAbsoluteTimeGetCurrent()
            //
            var sortResult: [String: [T]] = [:]
            var specialModels: [T] = []
            for (_, model) in models.enumerated() {
                var modelValue: String?
                
                if let keyPath = keyPath {
                    let mirror = Mirror(reflecting: model)
                    for (label, value) in mirror.children {
                        if let label = label, label == keyPath, let v = value as? String{
                            modelValue = v
                            break
                        }
                    }
                } else if let modelString = model as? String {
                    modelValue = modelString
                }
                
                if modelValue == nil {
                    continue
                }
                
                modelValue = modelValue!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                
                
                
                var englishFirstLetters: String = SwiftyWordsSort.getFirstEnglishWords(string: modelValue!)
                if self.polyphonicMap.keys.contains(modelValue!) {
                    englishFirstLetters = self.polyphonicMap[modelValue!]!
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
            
            let specialResultModel = SwiftyWordsSortResult<T>(key: self.specialSectionTitle, models: specialModels)
            
            if self.specialSectionTitleInsertAtFirst {
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
