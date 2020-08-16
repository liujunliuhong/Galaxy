//
//  SwiftyCityModel.swift
//  SwiftTool
//
//  Created by liujun on 2020/5/16.
//  Copyright © 2020 galaxy. All rights reserved.
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
        if nexts.count > 0 {
            nexts.forEach { (j) in
                let m = SwiftyCityModel(with: j)
                nextModels.append(m)
            }
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
        infoDic[kNexts] = self.nextsInfo(nexts: self.nexts)
        return infoDic
    }
    
    private func nextsInfo(nexts: [SwiftyCityModel]) -> [[String: Any]] {
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
