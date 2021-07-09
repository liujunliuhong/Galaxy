//
//  UIImage+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base: UIImage {
    /// 图片的高宽比
    public var heightRatio: CGFloat {
        if base.size.width.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return base.size.height / base.size.width
    }
    
    /// 图片的宽高比
    public var widthRatio: CGFloat {
        if base.size.height.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return base.size.width / base.size.height
    }
    
    /// 图片是否有`alpha`通道
    public var hasAlphaChannel: Bool {
        guard let cgImage = base.cgImage else { return false }
        let alpha = cgImage.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        return alpha == CGImageAlphaInfo.first.rawValue ||
            alpha == CGImageAlphaInfo.last.rawValue ||
            alpha == CGImageAlphaInfo.premultipliedFirst.rawValue ||
            alpha == CGImageAlphaInfo.premultipliedLast.rawValue
    }
    
    /// 裁剪图片
    public func crop(to rect: CGRect) -> UIImage? {
        let rect = CGRect(x: rect.origin.x * base.scale,
                          y: rect.origin.y * base.scale,
                          width: rect.width * base.scale,
                          height: rect.height * base.scale)
        guard base.size.width > 0, base.size.height > 0 else { return nil }
        guard let cgImage = base.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: base.scale, orientation: base.imageOrientation)
    }
}

extension GL where Base: UIImage {
    
    /// 根据质量压缩图片
    /// - Parameters:
    ///   - maxLength: 最大字节
    ///   - isForce: 是否强制压缩到小于最大字节
    /// - Returns: 图片`Data`
    public func compressedQuality(maxLength: UInt64, with isForce: Bool = true) -> Data? {
        guard var data = base.jpegData(compressionQuality: 1) else { return nil }
        guard data.count > maxLength else { return data }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        var compression: CGFloat = 1
        
        for _ in 0 ..< (isForce ? .max : 6) {
            compression = (max + min) / 2
            data = base.jpegData(compressionQuality: compression) ?? Data()
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9, compression < 0.99 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return data
    }
    
    /// 根据尺寸压缩图片
    /// - Parameter maxLength: 最大字节
    /// - Returns: 图片`Data`
    public func compressedSize(maxLength: UInt64) -> Data? {
        guard var data = base.jpegData(compressionQuality: 1) else { return nil }
        guard data.count > maxLength else { return data }
        
        var resultImage: UIImage = base
        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                              height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(origin: .zero, size: size))
            guard let temp = UIGraphicsGetImageFromCurrentImageContext() else { continue }
            resultImage = temp
            UIGraphicsEndImageContext()
            data = temp.jpegData(compressionQuality: 1) ?? Data()
        }
        return data
    }
    
    /// 压缩 (先根据质量压缩 如果质量无法满足则再根据尺寸压缩)
    /// - Parameter maxLength: 最大字节
    /// - Returns: 压缩后的数据 如果压缩失败则返回`nil`
    public func compressed(maxLength: UInt64) -> Data? {
        guard let data = base.gl.compressedQuality(maxLength: maxLength, with: false) else { return nil }
        guard data.count > maxLength else { return data }
        return UIImage(data: data, scale: base.scale)?.gl.compressedSize(maxLength: maxLength) ?? data
    }
}
