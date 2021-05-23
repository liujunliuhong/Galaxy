//
//  GLWordsSort.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public class GLWordsSort<T> {
    
    /// 排序结果
    public struct Result {
        public let key: String /// `key`
        public let models: [T] /// `key`下对应的数组集合
        public init(key: String, models: [T]) {
            self.key = key
            self.models = models
        }
    }
    
    /// 特殊索引文本，默认`#`
    public var specialSectionTitle: String = "#"
    
    /// 是否顺序颠倒，默认是按照A到Z进行排序，颠倒之后是Z到A进行排序
    public var reverse: Bool = false
    
    /// 特殊索引是否显示在第一个位置，默认`true`
    public var specialSectionTitleInsertAtFirst: Bool = true
    
    /// 额外的多音字
    public var extraPolyphonicMap: [String: String] = [:] {
        didSet {
            for (_, map) in extraPolyphonicMap.enumerated() {
                self.polyphonicMap[map.key] = map.value
            }
        }
    }
    
    /// DEBUG模式下，是否开启日志打印
    public var enableDebugLog: Bool = true
    
    // 默认的多音字
    public private(set) lazy var polyphonicMap: [String: String] = {
        return ["长安": "CA",
                "厦门": "XM",
                "曾经": "CJ",
                "重庆": "CQ",
                "长城": "CC",
                "地球": "DQ",
                "朝阳": "ZY",
                "犍为": "QW"]
    }()
    
    public init() {
        
    }
}

extension GLWordsSort {
    
    /// 获取字符串中每个字符所对应的英文的首字母
    ///
    /// 你好 -> NH
    public static func getFirstEnglishWords(string: String) -> String {
        let string = string.uppercased()
        var result: String = ""
        for scalar in string.unicodeScalars {
            let code = Int(scalar.value)
            if code >= 65 && code <= 90 { /* a - z */
                result.append(String(scalar))
            } else if code >= 97 && code <= 122 { /* A - Z */
                result.append(String(scalar))
            } else {
                let index = code - 19968
                if index >= 0 && index < gl_firstLetterArray.count { /* 索引里面查找 */
                    let s = gl_firstLetterArray.gl.string(index: index) ?? ""
                    result.append(s)
                } else { /* 特殊字符 */
                    result.append(String(scalar))
                }
            }
        }
        return result.uppercased()
    }
    
    /// 使用系统方法获取字符串的拼音
    public static func getFullEnglishWords(string: String) -> String? {
        let str = NSMutableString(string: string) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                return str as String
            }
        }
        return nil
    }
    
    /// 数组排序
    ///
    ///     fileprivate struct Model {
    ///         let title: String
    ///         init(title: String) {
    ///             self.title = title
    ///         }
    ///     }
    ///
    ///     private var results: [GLWordsSort.Result] = []
    ///     var models: [Model] = []
    ///     for _ in 0..<50 {
    ///         let string = ""
    ///         let model = Model(title: string)
    ///         models.append(model)
    ///     }
    ///
    ///     let sort = GLWordsSort<Model>()
    ///     sort.sort(models: models, keyPath: "title") { [weak self] (results) in
    ///         // ...
    ///     }
    ///
    /// `models`可以为模型数组(支持结构体)，也可以为字符串数组
    /// `keyPath`是模型中要排序的`key`
    /// 如果是字符串数组排序，那么`keyPath`无效，传`nil`
    public func sort(models: [T], keyPath: String?, closure: (([GLWordsSort.Result]) -> ())?) {
        _sort(models: models, keyPath: keyPath, closure: closure)
    }
}

extension GLWordsSort {
    private func _sort(models: [T], keyPath: String?, closure: (([GLWordsSort.Result]) -> ())?) {
        DispatchQueue.global().async {
            // check
            if models.count <= 0 {
                #if DEBUG
                if self.enableDebugLog {
                    print("排序数组为空")
                }
                #endif
                DispatchQueue.main.async {
                    closure?([])
                }
                return
            }
            
            #if DEBUG
            if self.enableDebugLog {
                print("开始排序")
            }
            #endif
            
            let startTime = CFAbsoluteTimeGetCurrent()
            //
            var sortResult: [String: [T]] = [:]
            var specialModels: [T] = []
            //
            for (_, model) in models.enumerated() {
                var modelValue: String?
                if let modelString = model as? String {
                    modelValue = modelString
                } else if let keyPath = keyPath {
                    let mirror = Mirror(reflecting: model)
                    for (label, value) in mirror.children {
                        if let label = label, label == keyPath, let v = value as? String {
                            modelValue = v
                            break
                        }
                    }
                }
                if modelValue == nil {
                    continue
                }
                
                modelValue = modelValue!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                
                var englishFirstLetters: String = GLWordsSort.getFirstEnglishWords(string: modelValue!)
                if self.polyphonicMap.keys.contains(modelValue!) { /* 多音字处理 */
                    englishFirstLetters = self.polyphonicMap[modelValue!]!
                }
                
                #if DEBUG
                if self.enableDebugLog {
                    print("\(englishFirstLetters)")
                }
                #endif
                
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
            
            // 索引排序
            var newKeys: [String] = []
            if self.reverse {
                newKeys = sortResult.keys.sorted { (s1, s2) -> Bool in
                    return s1 >= s2
                }
            } else {
                newKeys = sortResult.keys.sorted { (s1, s2) -> Bool in
                    return s1 <= s2
                }
            }
            
            var results: [GLWordsSort.Result] = []
            newKeys.forEach { (key) in
                let tmpModels = sortResult[key]!
                let m = GLWordsSort.Result(key: key, models: tmpModels)
                results.append(m)
            }
            
            if specialModels.count > 0 {
                let specialResultModel = GLWordsSort.Result(key: self.specialSectionTitle, models: specialModels)
                if self.specialSectionTitleInsertAtFirst {
                    results.insert(specialResultModel, at: 0)
                } else {
                    results.append(specialResultModel)
                }
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            
            #if DEBUG
            if self.enableDebugLog {
                print("结束排序")
                print("排序耗时: \(endTime - startTime)s")
            }
            #endif
            
            DispatchQueue.main.async {
                closure?(results)
            }
        }
    }
}
