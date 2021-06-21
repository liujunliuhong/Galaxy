//
//  BTCScript.swift
//  Galaxy
//
//  Created by liujun on 2021/6/17.
//

import Foundation

/// https://en.bitcoin.it/wiki/Script
public class BTCScript {
    
    public private(set) var chuncks: [BTCScriptChunk] = []
    
    
    public convenience init?(hexString: String?) {
        self.init(data: hexString?.gl.toHexData)
    }
    
    public init?(data: Data?) {
        let chuncks = decodeData(data: data) ?? []
        if chuncks.count <= 0 {
            return nil
        }
        self.chuncks = chuncks
    }
    
    public init?(string: String?) {
        
    }
    
}


extension BTCScript {
    private func decodeData(data: Data?) -> [BTCScriptChunk]? {
        guard let data = data else { return nil }
        guard data.count > 0 else { return nil }
        
        var i = 0
        var chuncks: [BTCScriptChunk] = []
        
        while i < data.count {
            guard let chunck = BTCScriptChunk.decodeScriptData(scriptData: data, offset: i) else {
                return nil
            }
            chuncks.append(chunck)
            i += chunck.range.upperBound
        }
        return chuncks
    }
    
    private func decodeString(string: String?) -> [BTCScriptChunk]? {
        
    }
}


extension BTCScript {
    private subscript(chunck index: Int) -> JSON {
        get {
            if type != .array {
                var r = JSON.null
                r.error = self.error ?? SwiftyJSONError.wrongType
                return r
            } else if rawArray.indices.contains(index) {
                return JSON(rawArray[index])
            } else {
                var r = JSON.null
                r.error = SwiftyJSONError.indexOutOfBounds
                return r
            }
        }
        set {
            if type == .array &&
                rawArray.indices.contains(index) &&
                newValue.error == nil {
                rawArray[index] = newValue.object
            }
        }
    }
}
