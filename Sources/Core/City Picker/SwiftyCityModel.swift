//
//  SwiftyCityModel.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let kAreaId: String = "areaId"
fileprivate let kAreaName: String = "areaName"
fileprivate let kNexts: String = "nexts"

public class SwiftyCityModel {
    public let areaId: String
    public let areaName: String
    public let nexts: [SwiftyCityModel]
    
    public init(with json: JSON) {
        let areaId: String = json[kAreaId].stringValue
        let areaName: String = json[kAreaName].stringValue
        
        var nextModels: [SwiftyCityModel] = []
        let nexts = json[kNexts].arrayValue
        nexts.forEach { (j) in
            let m = SwiftyCityModel(with: j)
            nextModels.append(m)
        }
        
        self.areaId = areaId
        self.areaName = areaName
        self.nexts = nextModels
    }
}

extension SwiftyCityModel: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        return "\(self.info())"
    }
    
    public var description: String {
        return "\(self.info())"
    }
    
    private func info() -> Any {
        var infoDic: [String: Any] = [:]
        infoDic[kAreaId] = self.areaId
        infoDic[kAreaName] = self.areaName
        
        var infos: [[String: Any]] = []
        self.nexts.forEach { (n) in
            var _infoDic: [String: Any] = [:]
            _infoDic[kAreaId] = n.areaId
            _infoDic[kAreaName] = n.areaName
            if n.nexts.count > 0 {
                _infoDic[kNexts] = n.nextsInfo()
            } else {
                _infoDic[kNexts] = []
            }
            infos.append(_infoDic)
        }
        infoDic[kNexts] = infos
        
        return infoDic
    }
    
    private func nextsInfo() -> [[String: Any]] {
        var infos: [[String: Any]] = []
        self.nexts.forEach { (n) in
            var infoDic: [String: Any] = [:]
            infoDic[kAreaId] = n.areaId
            infoDic[kAreaName] = n.areaName
            if n.nexts.count > 0 {
                infoDic[kNexts] = self.nextsInfo()
            } else {
                infoDic[kNexts] = []
            }
            infos.append(infoDic)
        }
        return infos
    }
}
