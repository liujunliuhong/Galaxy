//
//  GLHud.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

fileprivate let successImage: UIImage? = UIImage.gl_image(bundle: GLHud.bundle(), name: "success")
fileprivate let errorImage: UIImage? = UIImage.gl_image(bundle: GLHud.bundle(), name: "error")
fileprivate let infoImage: UIImage? = UIImage.gl_image(bundle: GLHud.bundle(), name: "info")
fileprivate let warnImage: UIImage? = UIImage.gl_image(bundle: GLHud.bundle(), name: "warn")

public enum GLHudType {
    case success
    case error
    case info
    case warn
    case custom(image: UIImage?)
}

public typealias GLHudHideCompletionClosure = () -> ()

public class GLHud: NSObject {
    
}

extension GLHud {
    fileprivate static func bundle() -> Bundle? {
        guard let path = Bundle(for: self.classForCoder()).path(forResource: "GLHud", ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }
}

extension GLHud {
    
    /// 显示loading
    @discardableResult
    public static func showLoading(message: String?,
                                   configuration:((MBProgressHUD?)->())? = nil,
                                   view: UIView? = nil) -> MBProgressHUD? {
        assert(Thread.isMainThread, "MBProgressHUD must in main thread.")
        return _getHUD(message: message, configuration: configuration, view: view)
    }
    
    /// 显示一段提示信息
    public static func showTips(message: String?,
                                configuration:((MBProgressHUD?)->())? = nil,
                                type: GLHudType?,
                                view: UIView? = nil,
                                afterDelay: TimeInterval = 1.5,
                                hideCompletionClosure: GLHudHideCompletionClosure? = nil) {
        DispatchQueue.main.async {
            var image: UIImage?
            switch type {
            case .success:
                image = successImage
            case .error:
                image = errorImage
            case .info:
                image = infoImage
            case .warn:
                image = warnImage
            case .custom(let customImage):
                image = customImage
            case .none:
                image = nil
            }
            
            let hud = _getHUD(message: message, view: view)
            if image != nil {
                let imageView = UIImageView(image: image)
                hud?.mode = .customView
                hud?.customView = imageView
            }
            hud?.hide(animated: true, afterDelay: afterDelay)
            hud?.completionBlock = hideCompletionClosure
            configuration?(hud)
        }
    }
    
    /// 隐藏hud
    public static func hide(hud: MBProgressHUD?) {
        DispatchQueue.main.async {
            hud?.hide(animated: true)
        }
    }
}


@discardableResult
fileprivate func _getHUD(message: String?,
                         configuration:((MBProgressHUD?)->())? = nil,
                         view: UIView?) -> MBProgressHUD? {
    var view = view
    if view == nil {
        view = UIApplication.shared.keyWindow
        if view == nil {
            view = UIApplication.shared.windows.first
        }
    }
    if view == nil {
        return nil
    }
    
    let hud = MBProgressHUD.showAdded(to: view! , animated: true)
    hud.minSize = CGSize(width: 100.0, height: 40.0)
    hud.label.text = message ?? ""
    hud.label.font = UIFont(name: "PingFangSC-Regular", size: 13)
    hud.label.textColor = UIColor.gl_rgba(R: 255, G: 255, B: 255)
    hud.label.numberOfLines = 0
    hud.margin = 20
    hud.bezelView.style = .solidColor
    hud.bezelView.color = UIColor(white: 0, alpha: 0.8)
    hud.removeFromSuperViewOnHide = true
    hud.contentColor = UIColor.gl_rgba(R: 255, G: 255, B: 255)
    configuration?(hud)
    return hud
}
