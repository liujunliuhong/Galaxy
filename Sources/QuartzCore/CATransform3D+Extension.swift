//
//  CATransform3D+Extension.swift
//  Galaxy
//
//  Created by liujun on 2021/7/9.
//

import Foundation
import QuartzCore
import UIKit


extension GL where Base == CATransform3D {
    /// `3D`透视
    /// - Parameters:
    ///   - center: 相机位置
    ///   - disZ: 深度 (相机与平面距离)
    /// - Returns: `CATransform3D`
    public static func CATransform3DMakePerspective(_ center: CGPoint, _ disZ: CGFloat) -> CATransform3D {
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
        let transBack = CATransform3DMakeTranslation(center.x, center.y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / disZ
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
    }
    
    /// `3D`透视
    /// - Parameters:
    ///   - t: 连接矩阵
    ///   - center: 相机位置
    ///   - disZ: 深度 (相机与平面距离)
    /// - Returns: `CATransform3D`
    public static func CATransform3DPerspect(_ t: CATransform3D, center: CGPoint, disZ: CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, GL<CATransform3D>.CATransform3DMakePerspective(center, disZ))
    }
}
