//
//  GLCityModel.swift
//  PickerView
//
//  Created by galaxy on 2020/10/25.
//

import Foundation

fileprivate let kAreaId: String = "areaId"
fileprivate let kAreaName: String = "areaName"
fileprivate let kNexts: String = "nexts"

public class GLCityModel {
    public let areaId: String
    public let areaName: String
    public let nexts: [GLCityModel]
    
    public init(with data: [String: Any]) {
        var areaId: String = ""
        var areaName: String = ""
        if let _areaId = data[kAreaId] as? String {
            areaId = _areaId
        }
        if let _areaName = data[kAreaName] as? String {
            areaName = _areaName
        }
        
        var nextModels: [GLCityModel] = []
        if let nexts = data[kNexts] as? [[String: Any]], nexts.count > 0  {
            nexts.forEach { (j) in
                let m = GLCityModel(with: j)
                nextModels.append(m)
            }
        }
        
        self.areaId = areaId
        self.areaName = areaName
        self.nexts = nextModels
    }
}

extension GLCityModel: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        return String(format: "%@", self.info()).gl_unicodeToUTF8 ?? ""
    }
    
    public var description: String {
        return String(format: "%@", self.info()).gl_unicodeToUTF8 ?? ""
    }
    
    public func info() -> [String: Any] {
        var infoDic: [String: Any] = [:]
        infoDic[kAreaId] = self.areaId
        infoDic[kAreaName] = self.areaName
        infoDic[kNexts] = self.nextsInfo(nexts: self.nexts)
        return infoDic
    }
    
    private func nextsInfo(nexts: [GLCityModel]) -> [[String: Any]] {
        var infos: [[String: Any]] = []
        nexts.forEach { (n) in
            var infoDic: [String: Any] = [:]
            infoDic[kAreaId] = n.areaId
            infoDic[kAreaName] = n.areaName
            if n.nexts.count > 0 {
                infoDic[kNexts] = self.nextsInfo(nexts: n.nexts)
            } else {
                infoDic[kNexts] = []
            }
            infos.append(infoDic)
        }
        return infos
    }
}
