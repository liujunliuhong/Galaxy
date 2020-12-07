//
//  GLDatingPhotoManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLDatingPhotoManager {
    public static let `default` = GLDatingPhotoManager()
    private init() {}
}

extension GLDatingPhotoManager {
    /// 生成一个图片名字
    public func generateImageName() -> String {
        return "\(UUID().uuidString).png"
    }
    
    /// 保存图片到本地
    public func saveImage(image: UIImage?, imageName: String?) {
        guard let image = image else { return }
        guard let imageName = imageName else { return }
        guard let directory = GLDocumentDirectory else { return }
        
        let directoryPath = URL(fileURLWithPath: directory).appendingPathComponent("GLDatingPhoto").path
        var isDir: ObjCBool = ObjCBool(true)
        let isExists = FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDir)
        if !isExists {
            try? FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fullPath = directoryPath + "/" + imageName
        try? image.pngData()?.write(to: URL(fileURLWithPath: fullPath))
    }
    
    /// 从本地获取图片
    public func getImage(imageName: String?) -> UIImage? {
        guard let imageName = imageName else { return nil }
        guard let directory = GLDocumentDirectory else { return nil }
        let directoryPath = URL(fileURLWithPath: directory).appendingPathComponent("GLDatingPhoto").path
        let fullPath = directoryPath + "/" + imageName
        return UIImage(contentsOfFile: fullPath)
    }
}
