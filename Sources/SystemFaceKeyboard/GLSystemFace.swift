//
//  GLSystemFace.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/31.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public class GLSystemFace: NSObject {
    public let value: String
    public init(value: String) {
        self.value = value
        super.init()
    }
}

public class GLSystemFaceDelete: NSObject {
    public let image: UIImage?
    public override init() {
        self.image = UIImage.gl_image(bundle: GLSystemFaceDelete._bundle(), name: "delete")
        super.init()
    }
    
    private static func _bundle() -> Bundle? {
        guard let path = Bundle(for: GLSystemFaceDelete.classForCoder()).path(forResource: "GLSystemFace", ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }
}

public class GLSystemFaceEmpty: NSObject {}
