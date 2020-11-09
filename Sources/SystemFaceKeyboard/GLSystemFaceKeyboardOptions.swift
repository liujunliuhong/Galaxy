//
//  GLSystemFaceKeyboardOptions.swift
//  SwiftTool
//
//  Created by galaxy on 2020/11/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import Photos
import UIKit

public struct GLSystemFaceKeyboardInset {
    public let top: CGFloat
    public let bottom: CGFloat
    
    public static let zero: GLSystemFaceKeyboardInset = GLSystemFaceKeyboardInset(top: .zero, bottom: .zero)
}

public class GLSystemFaceKeyboardOptions {
    /// 行
    public var row: Int = 3
    /// 列
    public var column: Int = 5
    /// 表情行间距
    public var lineSpacing: CGFloat = .zero
    /// 表情列间距
    public var interitemSpacing: CGFloat = .zero
    /// 表情`containerView`偏移量
    public var inset: UIEdgeInsets = .zero
    /// 指示器偏移量
    public var indicatorInset: GLSystemFaceKeyboardInset = GLSystemFaceKeyboardInset(top: .zero, bottom: .zero)
    /// 表情size
    public var faceSize: CGFloat = 30.0
    
    public init() {}
}



fileprivate func gl_emoji_to_symbol(x: Int64) -> Int64 {
    let s1 = (x & 0x3F000) >> 4
    let s2 = 0x808080F0 | s1
    let s3 = (x & 0xFC0) << 10
    let s4 = s2 | s3
    let s5 = (x & 0x1C0000) << 18
    let s6 = s4 | s5
    let s7 = (x & 0x3F) << 24
    let s8 = s6 | s7
    return s8
}

public func GL_GetAllSystemEmojis() -> [String] {
    var result: [String] = []
    for i in 0x1F600...0x1F64F {
        if i < 0x1F641 || i > 0x1F644 {
            var sym = gl_emoji_to_symbol(x: Int64(i))
            if let emoj = NSString(bytes: &sym, length: MemoryLayout<Int32>.size, encoding: String.Encoding.utf8.rawValue) {
                result.append(emoj as String)
            }
        }
    }
    return result
}

/// 获取系统表情（已经分好组了）
public func GL_GetAllSystemEmojis(row: Int, column: Int, closure: (([[AnyObject]])->())?) {
    assert(row > 0)
    assert(column > 0)
    DispatchQueue.global().async {
        let pageSize: Int = row * column
        //
        var faces: [AnyObject] = []
        //
        for (i, emoji) in GL_GetAllSystemEmojis().enumerated() {
            let face = GLSystemFace(value: emoji)
            if i > 0 && (i % (pageSize - 1) == 0) {
                let delete = GLSystemFaceDelete()
                faces.append(delete)
                faces.append(face)
            } else {
                faces.append(face)
            }
        }
        if faces.count <= 0 {
            DispatchQueue.main.async {
                closure?([])
            }
            return
        }
        if !(faces.last!.isKind(of: GLSystemFaceDelete.classForCoder())) {
            let delete = GLSystemFaceDelete()
            faces.append(delete)
        }
        let emptyCount: Int = pageSize - (faces.count % pageSize)
        for _ in 0..<emptyCount {
            let empty = GLSystemFaceEmpty()
            faces.insert(empty, at: faces.count - 1)
        }
        
        var sortFaces: [[AnyObject]] = []
        let repeatCount: Int = faces.count / pageSize
        for i in 0..<repeatCount {
            let elements = Array(faces[(i * pageSize)..<(pageSize+(i * pageSize))])
            sortFaces.append(elements)
        }
        DispatchQueue.main.async {
            closure?(sortFaces)
        }
    }
}
