//
//  SwiftyMBHUD.swift
//  SwiftTool
//
//  Created by apple on 2020/5/11.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

fileprivate let successImage: UIImage? = SwiftyMBHUD.image(name: "SwiftyMBHUD_Success")
fileprivate let errorImage: UIImage? = SwiftyMBHUD.image(name: "SwiftyMBHUD_Error")
fileprivate let infoImage: UIImage? = SwiftyMBHUD.image(name: "SwiftyMBHUD_Info")
fileprivate let warnImage: UIImage? = SwiftyMBHUD.image(name: "SwiftyMBHUD_Warn")

@objc public enum SwiftyMBHUDType: Int {
    case success
    case error
    case info
    case warn
}

public typealias SwiftyMBHUDHideCompletionClosure = ()->()

@objc public class SwiftyMBHUD: NSObject {
    
}

extension SwiftyMBHUD {
    fileprivate static func bundle() -> Bundle? {
        guard let path = Bundle(for: self.classForCoder()).path(forResource: "SwiftyHUD", ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }
    
    fileprivate static func image(name: String?) -> UIImage? {
        guard let name = name, name.count > 0 else { return nil }
        var scale = Int(UIScreen.main.scale)
        if scale < 2 {
            scale = 2
        } else if scale > 3 {
            scale = 3
        }
        let newName = "\(name)@\(scale)x"
        
        var image: UIImage? = nil
        if let path = SwiftyMBHUD.bundle()?.path(forResource: newName, ofType: "png") {
            image = UIImage(contentsOfFile: path)
        } else if let path = SwiftyMBHUD.bundle()?.path(forResource: name, ofType: "png") {
            image = UIImage(contentsOfFile: path)
        }
        return image
    }
}

extension SwiftyMBHUD {
    
    /// show loading
    /// - Parameters:
    ///   - message: message
    ///   - view: view
    @discardableResult @objc public static func showLoading(message: String?, view: UIView? = nil) -> MBProgressHUD? {
        assert(Thread.isMainThread, "MBProgressHUD must in main thread.")
        return SwiftyMBHUD.getHUD(message: message, view: view)
    }
    
    /// show image hud
    /// - Parameters:
    ///   - message: message
    ///   - type: type
    ///   - view: view
    ///   - afterDelay: after delay hide
    ///   - hideCompletionClosure: closure
    @objc public static func showImageHUD(message: String?, type: SwiftyMBHUDType, view: UIView? = nil, afterDelay: TimeInterval = 1.5, hideCompletionClosure: SwiftyMBHUDHideCompletionClosure? = nil) {
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
            }
            
            let hud = SwiftyMBHUD.getHUD(message: message, view: view)
            let imageView = UIImageView(image: image)
            hud?.mode = .customView
            hud?.customView = imageView
            hud?.hide(animated: true, afterDelay: afterDelay)
            hud?.completionBlock = hideCompletionClosure
        }
    }
    
    
    /// show tips
    /// - Parameters:
    ///   - message: message
    ///   - view: view
    ///   - afterDelay: after delay hide
    ///   - hideCompletionClosure: closure
    @objc public static func showTips(message: String?, view: UIView? = nil, afterDelay: TimeInterval = 1.5, hideCompletionClosure: SwiftyMBHUDHideCompletionClosure? = nil) {
        DispatchQueue.main.async {
            let hud = SwiftyMBHUD.getHUD(message: message, view: view)
            hud?.mode = .text
            hud?.margin = 15.0
            hud?.hide(animated: true, afterDelay: afterDelay)
            hud?.completionBlock = hideCompletionClosure
        }
    }
}


extension SwiftyMBHUD {
    @discardableResult
    private static func getHUD(message: String?, view: UIView?) -> MBProgressHUD? {
        var view = view
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        if view == nil {
            return nil
        }
        
        let hud = MBProgressHUD.showAdded(to: view! , animated: true)
        hud.minSize = CGSize(width: 100.0, height: 40.0)
        hud.label.text = message ?? ""
        hud.label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        hud.label.textColor = .white
        hud.label.numberOfLines = 0
        hud.margin = 20
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.8)
        hud.removeFromSuperViewOnHide = true
        hud.contentColor = .white
        return hud
    }
}
