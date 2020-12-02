//
//  GLDatingMessageNotificationOptions.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public class GLDatingMessageNotificationOptions {
    /// 圆角（默认5.0）
    public var cornerRadius: CGFloat = 5.0
    /// 容器宽度
    public var containerWidth: CGFloat = UIScreen.main.bounds.width - 15.0 - 15.0
    /// 背景颜色（默认白色）
    public var backgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    /// 指示器颜色（默认`lightGray`）
    public var indicatorColor: UIColor = UIColor.lightGray
    /// 头像高度（默认45.0）
    public var avatarHeight: CGFloat = 45.0
    /// 默认头像（默认为灰色）
    public var defaultAvatarImage: UIImage? = image(color: .gray)
    
    /// 标题（默认为空）
    public var title: String?
    /// 标题字体（默认系统加粗15号字体）
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 15)
    /// 标题颜色（默认黑色）
    public var titleColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    /// 内容（默认为空）
    public var content: String?
    /// 内容字体（默认系统加粗14号字体）
    public var contentFont: UIFont = UIFont.boldSystemFont(ofSize: 14)
    /// 内容颜色（默认黑色偏灰）
    public var contentColor: UIColor = UIColor(red: 0.0, green: 0.07, blue: 0.1, alpha: 1.0)
    
    /// 用户ID（点击的时候，发送的通知里面会携带）
    public var userID: String?
    
    /// 头像链接（默认为空，当`remoteAvatarURLString`和`localAvatar`同时存在时，取`remoteAvatarURLString`）
    public var remoteAvatarURLString: String?
    /// 本地头像（默认为空）
    public var localAvatar: UIImage?
    
    public init() {
        
    }
}

/// 颜色转图片
private func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
