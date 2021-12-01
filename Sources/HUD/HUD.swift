//
//  HUD.swift
//  Galaxy
//
//  Created by liujun on 2021/6/30.
//

import Foundation
import UIKit
import MBProgressHUD

fileprivate let successImage: UIImage? = HUD.bundle()?.gl.image(name: "success")
fileprivate let errorImage: UIImage? = HUD.bundle()?.gl.image(name: "error")
fileprivate let infoImage: UIImage? = HUD.bundle()?.gl.image(name: "info")
fileprivate let warnImage: UIImage? = HUD.bundle()?.gl.image(name: "warn")



public typealias HUDHideCompletionClosure = () -> ()

private class _HUD_: NSObject {}

public class HUD {
    public enum HUDType {
        case success
        case error
        case info
        case warn
        case custom(image: UIImage?)
    }
}

extension HUD {
    fileprivate static func bundle() -> Bundle? {
        guard let path = Bundle(for: _HUD_.classForCoder()).path(forResource: "HUD", ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }
}

extension HUD {
    
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
                                type: HUD.HUDType?,
                                view: UIView? = nil,
                                afterDelay: TimeInterval = 1.5,
                                hideCompletionClosure: HUDHideCompletionClosure? = nil) {
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
            } else {
                hud?.mode = .text
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

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
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
    // @property(class, nonatomic, readonly) UIApplication *sharedApplication NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
    let hud = MBProgressHUD.showAdded(to: view! , animated: true)
    hud.minSize = CGSize(width: 100.0, height: 40.0)
    hud.label.text = message ?? ""
    hud.label.font = UIFont(name: "PingFangSC-Regular", size: 13)
    hud.label.textColor = GL<UIColor>.rgba(R: 255, G: 255, B: 255)
    hud.label.numberOfLines = 0
    hud.margin = 20
    hud.bezelView.style = .solidColor
    hud.bezelView.color = UIColor(white: 0, alpha: 0.8)
    hud.removeFromSuperViewOnHide = true
    hud.contentColor = GL<UIColor>.rgba(R: 255, G: 255, B: 255)
    configuration?(hud)
    return hud
}
