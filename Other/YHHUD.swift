//
//  YHHUD.swift
//  AlamofireTest
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import MBProgressHUD

class YHHUD: NSObject {
    // MARK: - MBProgressHUD -- 针对MBProgressHUD的简单封装
    // must in main thread.
    @objc static func showHUD(_ message: String? = nil, _ hudColor: UIColor = .black, _ contentColor: UIColor = .white, in view: UIView = UIApplication.shared.keyWindow!) -> MBProgressHUD {
        assert(Thread.isMainThread, "MBProgressHUD must in main thread.")
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.contentColor = contentColor
        hud.bezelView.style = .solidColor
        hud.bezelView.color = hudColor
        if let message = message, message.count > 0 {
            hud.label.text = message
            hud.label.numberOfLines = 0
        }
        hud.removeFromSuperViewOnHide = true
        return hud
    }
    
    @objc static func hideHUD(_ hud: MBProgressHUD?, closure:(()->())? = nil) -> Void {
        guard let hud = hud else { return }
        DispatchQueue.main.async {
            hud.hide(animated: true)
            hud.completionBlock = closure;
        }
    }
    
    @objc static func onlyShowTextHUD(_ message: String?, in view: UIView = UIApplication.shared.keyWindow!, afterDelay: TimeInterval = 1.5, closure:(()->())? = nil) -> Void {
        guard let message = message else {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view , animated: true)
            hud.mode = .text
            hud.contentColor = .white
            hud.bezelView.style = .solidColor
            hud.bezelView.color = UIColor.black.withAlphaComponent(1)
            hud.label.text = message
            hud.label.numberOfLines = 0
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: afterDelay)
            hud.completionBlock = closure
        }
    }
}
