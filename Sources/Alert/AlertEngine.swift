//
//  AlertEngine.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

fileprivate struct Keys {
    static var associatedKey = "com.galaxy.alertengine.key"
}

public class AlertEngine {
    public class Options {
        public var fromPosition: AlertEngine.FromPosition = .rightCenter(left: .zero)
        public var toPosition: AlertEngine.ToPostion = .center
        public var dismissPosition: AlertEngine.FromPosition = .none
        //
        public var enableMask: Bool = true
        public var shouldResignOnTouchOutside: Bool = true
        //
        public var duration: TimeInterval = 0.25
        public var translucentColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
        public var animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
        //
        public init() {}
    }
    
    public enum FromPosition: Equatable {
        case topLeft(bottom: CGFloat, left: CGFloat)
        case topCenter(bottom: CGFloat)
        case topRight(bottom: CGFloat, right: CGFloat)
        //
        case leftTop(right: CGFloat, top: CGFloat)
        case leftCenter(right: CGFloat)
        case leftBottom(right: CGFloat, bottom: CGFloat)
        //
        case bottomLeft(top: CGFloat, left: CGFloat)
        case bottomCenter(top: CGFloat)
        case bottomRight(top: CGFloat, right: CGFloat)
        //
        case rightTop(left: CGFloat, top: CGFloat)
        case rightCenter(left: CGFloat)
        case rightBottom(left: CGFloat, bottom: CGFloat)
        //
        case center
        //
        case none
    }
    
    public enum ToPostion {
        case topLeft(top: CGFloat, left: CGFloat)
        case topCenter(top: CGFloat)
        case topRight(top: CGFloat, right: CGFloat)
        case leftCenter(left: CGFloat)
        case bottomLeft(bottom: CGFloat, left: CGFloat)
        case bottomCenter(bottom: CGFloat)
        case bottomRight(bottom: CGFloat, right: CGFloat)
        case rightCenter(right: CGFloat)
        case center
    }
    
    private let defaultUsingSpringWithDamping: CGFloat = 0.75
    private let defaultInitialSpringVelocity: CGFloat = 7.0
    
    public static let `default` = AlertEngine()
    
    private var backgroundView: UIView?
    private var maskView: UIView?
    
    private var currentAlertView: UIView?
    
    private init() {
        
    }
}

extension AlertEngine {
    @available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
    public func show(parentView: UIView?, alertView: UIView?, options: AlertEngine.Options) {
        //
        guard let alertView = alertView else { return }
        //
        var tempParentView: UIView?
        if parentView != nil {
            tempParentView = parentView
        } else if let keyWindow = UIApplication.shared.keyWindow {
            tempParentView = keyWindow
        }
        if tempParentView == nil {
            return
        }
        //
        self.release()
        //
        if options.enableMask {
            let backgroundView = UIView()
            backgroundView.isUserInteractionEnabled = true
            
            let maskView = UIView()
            maskView.backgroundColor = options.translucentColor.withAlphaComponent(0)
            if options.shouldResignOnTouchOutside {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismissAction))
                maskView.addGestureRecognizer(tap)
            }
            tempParentView!.addSubview(backgroundView)
            backgroundView.addSubview(maskView)
            tempParentView!.addSubview(alertView)
            
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            maskView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            self.backgroundView = backgroundView
            self.maskView = maskView
            self.currentAlertView = alertView
        } else {
            tempParentView!.addSubview(alertView)
            self.currentAlertView = alertView
        }
        //
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWhenOrientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        //
        objc_setAssociatedObject(alertView, &Keys.associatedKey, options, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        //
        if options.fromPosition == .none {
            self.maskView?.backgroundColor = options.translucentColor
            setToPositionConstraints(view: alertView, toPosition: options.toPosition)
            return
        }
        //
        setFromPositionConstraints(view: alertView, fromPosition: options.fromPosition)
        alertView.superview?.layoutIfNeeded()
        alertView.layoutIfNeeded()
        //
        self.maskView?.isUserInteractionEnabled = false
        //
        setToPositionConstraints(view: alertView, toPosition: options.toPosition)
        //
        UIView.animate(withDuration: options.duration, delay: 0, usingSpringWithDamping: defaultUsingSpringWithDamping, initialSpringVelocity: defaultInitialSpringVelocity, options: options.animationOptions) {
            self.maskView?.backgroundColor = options.translucentColor
            alertView.superview?.layoutIfNeeded()
        } completion: { (_) in
            self.maskView?.isUserInteractionEnabled = true
        }
    }
    
    public func refresh() {
        refreshWhenOrientationDidChange()
    }
    
    public func dismiss() {
        if let currentAlertView = self.currentAlertView,
           let options = objc_getAssociatedObject(currentAlertView, &Keys.associatedKey) as? AlertEngine.Options,
           options.dismissPosition != .none {
            self.maskView?.isUserInteractionEnabled = false
            setDismissPositionConstraints(view: currentAlertView, dismissPosition: options.dismissPosition)
            UIView.animate(withDuration: options.duration, delay: 0, options: options.animationOptions) {
                self.maskView?.backgroundColor = options.translucentColor.withAlphaComponent(0)
                currentAlertView.superview?.layoutIfNeeded()
            } completion: { (_) in
                self.maskView?.isUserInteractionEnabled = true
                self.release()
            }
        } else {
            self.release()
        }
    }
}

extension AlertEngine {
    @objc private func tapDismissAction() {
        dismiss()
    }
    
    @objc private func refreshWhenOrientationDidChange() {
        backgroundView?.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        maskView?.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let currentAlertView = currentAlertView,
           let options = objc_getAssociatedObject(currentAlertView, &Keys.associatedKey) as? AlertEngine.Options {
            setToPositionConstraints(view: currentAlertView, toPosition: options.toPosition)
        }
    }
}

extension AlertEngine {
    private func release() {
        if let currentAlertView = self.currentAlertView {
            objc_setAssociatedObject(currentAlertView, &Keys.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        self.currentAlertView?.removeFromSuperview()
        self.maskView?.isUserInteractionEnabled = false
        self.maskView?.removeFromSuperview()
        self.backgroundView?.removeFromSuperview()
        self.currentAlertView = nil
        self.maskView = nil
        self.backgroundView = nil
    }
}

private func setFromPositionConstraints(view: UIView?, fromPosition: AlertEngine.FromPosition) {
    guard let view = view else { return }
    guard let superview = view.superview else { return }
    switch fromPosition {
    case .topLeft(let bottom, let left):
        view.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(left)
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .topCenter(let bottom):
        view.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .topRight(let bottom, let right):
        view.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-right)
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .leftTop(let right, let top):
        view.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(top)
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .leftCenter(let right):
        view.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .leftBottom(let right, let bottom):
        view.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .bottomLeft(let top, let left):
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
        })
    case .bottomCenter(let top):
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.centerX.equalToSuperview()
        })
    case .bottomRight(let top, let right):
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.right.equalToSuperview().offset(-right)
        })
    case .rightTop(let left, let top):
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .rightCenter(let left):
        view.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .rightBottom(let left, let bottom):
        view.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .center:
        view.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    case .none:
        fatalError()
    }
}

private func setToPositionConstraints(view: UIView?, toPosition: AlertEngine.ToPostion) {
    guard let view = view else { return }
    guard let _ = view.superview else { return }
    switch toPosition {
    case .topLeft(let top, let left):
        view.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.left.equalToSuperview().offset(left)
        }
    case .topCenter(let top):
        view.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.centerX.equalToSuperview()
        }
    case .topRight(let top, let right):
        view.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.right.equalToSuperview().offset(-right)
        }
    case .leftCenter(let left):
        view.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(left)
        }
    case .bottomLeft(let bottom, let left):
        view.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.left.equalToSuperview().offset(left)
        }
    case .bottomCenter(let bottom):
        view.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottom)
        }
    case .bottomRight(let bottom, let right):
        view.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-right)
            make.bottom.equalToSuperview().offset(-bottom)
        }
    case .rightCenter(let right):
        view.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-right)
        }
    case .center:
        view.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

private func setDismissPositionConstraints(view: UIView?, dismissPosition: AlertEngine.FromPosition) {
    guard let view = view else { return }
    guard let superview = view.superview else { return }
    switch dismissPosition {
    case .topLeft(let bottom, let left):
        view.snp.remakeConstraints({ (make) in
            make.left.equalToSuperview().offset(left)
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .topCenter(let bottom):
        view.snp.remakeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .topRight(let bottom, let right):
        view.snp.remakeConstraints({ (make) in
            make.right.equalToSuperview().offset(-right)
            make.bottom.equalTo(superview.snp.top).offset(-bottom)
        })
    case .leftTop(let right, let top):
        view.snp.remakeConstraints({ (make) in
            make.top.equalToSuperview().offset(top)
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .leftCenter(let right):
        view.snp.remakeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .leftBottom(let right, let bottom):
        view.snp.remakeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.right.equalTo(superview.snp.left).offset(-right)
        })
    case .bottomLeft(let top, let left):
        view.snp.remakeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.left.equalToSuperview().offset(left)
        })
    case .bottomCenter(let top):
        view.snp.remakeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.centerX.equalToSuperview()
        })
    case .bottomRight(let top, let right):
        view.snp.remakeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.right.equalToSuperview().offset(-right)
        })
    case .rightTop(let left, let top):
        view.snp.remakeConstraints({ (make) in
            make.top.equalTo(superview.snp.bottom).offset(top)
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .rightCenter(let left):
        view.snp.remakeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .rightBottom(let left, let bottom):
        view.snp.remakeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.left.equalTo(superview.snp.right).offset(left)
        })
    case .center:
        view.snp.remakeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    case .none:
        fatalError()
    }
}

