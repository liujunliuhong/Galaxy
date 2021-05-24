//
//  CityModel.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

fileprivate let kAreaId: String = "areaId"
fileprivate let kAreaName: String = "areaName"
fileprivate let kNexts: String = "nexts"

public class CityModel {
    public let areaId: String
    public let areaName: String
    public let nexts: [CityModel]
    
    public init(with data: [String: Any]) {
        var areaId: String = ""
        var areaName: String = ""
        if let _areaId = data[kAreaId] as? String {
            areaId = _areaId
        }
        if let _areaName = data[kAreaName] as? String {
            areaName = _areaName
        }
        
        var nextModels: [CityModel] = []
        if let nexts = data[kNexts] as? [[String: Any]],
           nexts.count > 0  {
            nexts.forEach { (j) in
                let m = CityModel(with: j)
                nextModels.append(m)
            }
        }
        
        self.areaId = areaId
        self.areaName = areaName
        self.nexts = nextModels
    }
}

extension CityModel: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        return "\(self._getInfo())"
    }
    
    public var description: String {
        return "\(self._getInfo())"
    }
    
    private func _getInfo() -> NSString {
        return NSString(format: "%@", self.info() as NSDictionary)
    }
    
    public func info() -> [String: Any] {
        var infoDic: [String: Any] = [:]
        infoDic[kAreaId] = self.areaId
        infoDic[kAreaName] = self.areaName
        infoDic[kNexts] = self.nextsInfo(nexts: self.nexts)
        return infoDic
    }
    
    private func nextsInfo(nexts: [CityModel]) -> [[String: Any]] {
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
