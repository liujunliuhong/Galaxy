//
//  HeightResult.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/27.
//

import Foundation


public final class HeightResult {
    public let cmHeight: CmHeight
    public let ftHeight: FtHeight
    
    public init(cmHeight: CmHeight, ftHeight: FtHeight) {
        self.cmHeight = cmHeight
        self.ftHeight = ftHeight
    }
}
