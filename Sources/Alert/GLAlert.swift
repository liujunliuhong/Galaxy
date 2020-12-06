//
//  GLAlert.swift
//  SwiftTool
//
//  Created by galaxy on 2020/11/28.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import SnapKit


public enum GLAlertFromPosition: Equatable {
    case topLeft(bottom: CGFloat, left: CGFloat)
    case topCenter(bottom: CGFloat)
    case topRight(bottom: CGFloat, right: CGFloat)
    
    case leftTop(right: CGFloat, top: CGFloat)
    case leftCenter(right: CGFloat)
    case leftBottom(right: CGFloat, bottom: CGFloat)
    
    case bottomLeft(top: CGFloat, left: CGFloat)
    case bottomCenter(top: CGFloat)
    case bottomRight(top: CGFloat, right: CGFloat)
    
    case rightTop(left: CGFloat, top: CGFloat)
    case rightCenter(left: CGFloat)
    case rightBottom(left: CGFloat, bottom: CGFloat)
    
    case none
}

public enum GLAlertDestinationPostion {
    /// 左上
    case topLeft(top: CGFloat, left: CGFloat)
    /// 上中
    case topCenter(top: CGFloat)
    /// 上右
    case topRight(top: CGFloat, right: CGFloat)
    /// 左中
    case leftCenter(left: CGFloat)
    /// 下左
    case bottomLeft(bottom: CGFloat, left: CGFloat)
    /// 下中
    case bottomCenter(bottom: CGFloat)
    /// 下右
    case bottomRight(bottom: CGFloat, right: CGFloat)
    /// 右中
    case rightCenter(right: CGFloat)
    /// 屏幕中间
    case center
}

public let GLAlertStartColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0)
public let GLAlertEndColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)

private let defaultOptions = GLAlertOptions(from: .topCenter(bottom: 0), to: .center, dismissTo: .none)
private let defaultUsingSpringWithDamping: CGFloat = 0.75
private let defaultInitialSpringVelocity: CGFloat = 7.0

public class GLAlert {
    public static let `default` = GLAlert()
    
    private var backgroundView: UIView?
    private var maskView: UIView?
    
    private var currentView: UIView?
    private var currentNode: ASDisplayNode?
    
    private init() {
        
    }
}

fileprivate struct Keys {
    static var associatedKey = "com.galaxy.glalert.associatedKey"
}

extension GLAlert {
    /// 显示(针对`ASDisplayNode`)
    @discardableResult
    public func show(node: ASDisplayNode?, containerWidth: CGFloat, options: GLAlertOptions) -> Bool {
        guard let keyWindow = UIApplication.shared.keyWindow else { return false }
        guard let node = node else { return false }
        
        self.immediatelyRelease()
        
        if options.enableMask {
            let backgroundView = UIView()
            backgroundView.isUserInteractionEnabled = true
            backgroundView.frame = keyWindow.bounds
            
            let maskView = UIView()
            maskView.frame = keyWindow.bounds
            maskView.backgroundColor = GLAlertStartColor
            if options.shouldResignOnTouchOutside {
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
                maskView.addGestureRecognizer(tap)
            }
            keyWindow.addSubview(backgroundView)
            backgroundView.addSubview(maskView)
            keyWindow.addSubnode(node)
            self.backgroundView = backgroundView
            self.maskView = maskView
        } else {
            keyWindow.addSubnode(node)
        }
        
        self.currentNode = node
        
        let containerHeight = node.layoutThatFits(ASSizeRangeMake(CGSize(width: containerWidth, height: 0), CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude))).size.height
        node.setNeedsLayout()
        node.layoutIfNeeded()
        
        objc_setAssociatedObject(node, &Keys.associatedKey, options, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if options.from == GLAlertFromPosition.none {
            self.maskView?.backgroundColor = options.translucentColor
            let frame = self.getEndFrame(to: options.to, containerWidth: containerWidth, containerHeight: containerHeight)
            node.frame = frame
            options.willShowClosure?()
            options.didShowClosure?()
            return true
        }
        
        let initialFrame = getInitialFrame(from: options.from, containerWidth: containerWidth, containerHeight: containerHeight)
        node.frame = initialFrame
        
        self.maskView?.isUserInteractionEnabled = false
        
        options.willShowClosure?()
        UIView.animate(withDuration: options.duration, delay: 0, usingSpringWithDamping: defaultUsingSpringWithDamping, initialSpringVelocity: defaultInitialSpringVelocity, options: options.animationOptions) {
            self.maskView?.backgroundColor = options.translucentColor
            node.frame = self.getEndFrame(to: options.to, containerWidth: containerWidth, containerHeight: containerHeight)
        } completion: { (_) in
            options.didShowClosure?()
            self.maskView?.isUserInteractionEnabled = true
        }
        
        return true
    }
}

extension GLAlert {
    /// 显示(针对`UIView`)
    @discardableResult
    public func show(view: UIView?, options: GLAlertOptions) -> Bool {
        guard let keyWindow = UIApplication.shared.keyWindow else { return false }
        guard let view = view else { return false }
        self.immediatelyRelease()
        
        if options.enableMask {
            let backgroundView = UIView()
            backgroundView.isUserInteractionEnabled = true
            backgroundView.frame = keyWindow.bounds
            
            let maskView = UIView()
            maskView.frame = keyWindow.bounds
            maskView.backgroundColor = GLAlertStartColor
            if options.shouldResignOnTouchOutside {
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
                maskView.addGestureRecognizer(tap)
            }
            keyWindow.addSubview(backgroundView)
            backgroundView.addSubview(maskView)
            keyWindow.addSubview(view)
            self.currentView = view
            self.backgroundView = backgroundView
            self.maskView = maskView
        } else {
            keyWindow.addSubview(view)
            self.currentView = view
        }
        
        objc_setAssociatedObject(view, &Keys.associatedKey, options, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if options.from == GLAlertFromPosition.none {
            self.maskView?.backgroundColor = options.translucentColor
            self.setEndViewConstraints(view: view, to: options.to)
            options.willShowClosure?()
            options.didShowClosure?()
            return true
        }
        
        self.setInitialViewConstraints(view: view, from: options.from, isRemake: false)
        view.superview?.layoutIfNeeded()
        view.layoutIfNeeded()
        
        self.maskView?.isUserInteractionEnabled = false
        
        self.setEndViewConstraints(view: view, to: options.to)
        
        options.willShowClosure?()
        UIView.animate(withDuration: options.duration, delay: 0, usingSpringWithDamping: defaultUsingSpringWithDamping, initialSpringVelocity: defaultInitialSpringVelocity, options: options.animationOptions) {
            self.maskView?.backgroundColor = options.translucentColor
            view.superview?.layoutIfNeeded()
        } completion: { (_) in
            options.didShowClosure?()
            self.maskView?.isUserInteractionEnabled = true
        }
        return true
    }
}

extension GLAlert {
    /// dismiss
    @objc public func dismiss() {
        if let currentView = self.currentView {
            let options = (objc_getAssociatedObject(currentView, &Keys.associatedKey) as? GLAlertOptions) ?? defaultOptions
            if options.dismissTo == GLAlertFromPosition.none {
                self.immediatelyRelease()
                return
            }
            self.maskView?.isUserInteractionEnabled = false
            options.willDismissClosure?()
            self.setInitialViewConstraints(view: currentView, from: options.dismissTo, isRemake: true)
            UIView.animate(withDuration: options.duration, delay: 0, options: options.animationOptions) {
                self.maskView?.backgroundColor = GLAlertStartColor
                self.currentView?.superview?.layoutIfNeeded()
            } completion: { (_) in
                self.maskView?.isUserInteractionEnabled = true
                options.didDismissClosure?()
                self.release()
            }
        }
        if let currentNode = self.currentNode {
            let options = (objc_getAssociatedObject(currentNode, &Keys.associatedKey) as? GLAlertOptions) ?? defaultOptions
            if options.dismissTo == GLAlertFromPosition.none {
                self.immediatelyRelease()
                return
            }
            let nodeSize: CGSize = currentNode.frame.size
            self.maskView?.isUserInteractionEnabled = false
            options.willDismissClosure?()
            UIView.animate(withDuration: options.duration, delay: 0, options: options.animationOptions) {
                self.maskView?.backgroundColor = GLAlertStartColor
                currentNode.frame = self.getInitialFrame(from: options.dismissTo, containerWidth: nodeSize.width, containerHeight: nodeSize.height)
            } completion: { (_) in
                self.maskView?.isUserInteractionEnabled = true
                options.didDismissClosure?()
                self.release()
            }
        }
    }
}

extension GLAlert {
    private func immediatelyRelease() {
        if let currentView = self.currentView, let options = objc_getAssociatedObject(currentView, &Keys.associatedKey) as? GLAlertOptions {
            options.willDismissClosure?()
            options.didDismissClosure?()
            objc_setAssociatedObject(currentView, &Keys.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if let currentNode = self.currentNode, let options = objc_getAssociatedObject(currentNode, &Keys.associatedKey) as? GLAlertOptions {
            options.willDismissClosure?()
            options.didDismissClosure?()
            objc_setAssociatedObject(currentNode, &Keys.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.currentNode?.removeFromSupernode()
        self.currentNode = nil
        self.currentView?.removeFromSuperview()
        self.currentView = nil
        self.maskView?.backgroundColor = GLAlertStartColor
        self.maskView?.isUserInteractionEnabled = false
        self.maskView?.removeFromSuperview()
        self.backgroundView?.removeFromSuperview()
        self.maskView = nil
        self.backgroundView = nil
    }
    
    private func release() {
        if let currentView = self.currentView {
            objc_setAssociatedObject(currentView, &Keys.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if let currentNode = self.currentNode {
            objc_setAssociatedObject(currentNode, &Keys.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.currentNode?.removeFromSupernode()
        self.currentNode = nil
        self.currentView?.removeFromSuperview()
        self.maskView?.backgroundColor = GLAlertStartColor
        self.maskView?.isUserInteractionEnabled = false
        self.maskView?.removeFromSuperview()
        self.backgroundView?.removeFromSuperview()
        self.currentView = nil
        self.maskView = nil
        self.backgroundView = nil
    }
}




extension GLAlert {
    /// 获取初始frame
    private func getInitialFrame(from: GLAlertFromPosition, containerWidth: CGFloat, containerHeight: CGFloat) -> CGRect {
        var rect: CGRect = .zero
        rect.size.width = containerWidth
        rect.size.height = containerHeight
        switch from {
            case .topLeft(let bottom, let left):
                rect.origin.x = left
                rect.origin.y = -containerHeight - bottom
            case .topCenter(let bottom):
                rect.origin.x = (UIScreen.main.bounds.width - containerWidth) / 2.0
                rect.origin.y = -containerHeight - bottom
            case .topRight(let bottom, let right):
                rect.origin.x = UIScreen.main.bounds.width - containerWidth - right
                rect.origin.y = -containerHeight - bottom
            case .leftTop(let right, let top):
                rect.origin.x = -containerWidth - right
                rect.origin.y = top
            case .leftCenter(let right):
                rect.origin.x = -containerWidth - right
                rect.origin.y = (UIScreen.main.bounds.height - containerHeight) / 2.0
            case .leftBottom(let right, let bottom):
                rect.origin.x = -containerWidth - right
                rect.origin.y = UIScreen.main.bounds.height - containerHeight - bottom
            case .bottomLeft(let top, let left):
                rect.origin.x = left
                rect.origin.y = UIScreen.main.bounds.height + top
            case .bottomCenter(let top):
                rect.origin.x = (UIScreen.main.bounds.width - containerWidth) / 2.0
                rect.origin.y = UIScreen.main.bounds.height + top
            case .bottomRight(let top, let right):
                rect.origin.x = UIScreen.main.bounds.width - containerWidth - right
                rect.origin.y = UIScreen.main.bounds.height + top
            case .rightTop(let left, let top):
                rect.origin.x = UIScreen.main.bounds.width + left
                rect.origin.y = top
            case .rightCenter(let left):
                rect.origin.x = UIScreen.main.bounds.width + left
                rect.origin.y = (UIScreen.main.bounds.height - containerHeight) / 2.0
            case .rightBottom(let left, let bottom):
                rect.origin.x = UIScreen.main.bounds.width + left
                rect.origin.y = UIScreen.main.bounds.height - containerHeight - bottom
            case .none:
                rect = .zero
        }
        return rect
    }
    
    /// 获取最终显示的frame
    private func getEndFrame(to: GLAlertDestinationPostion, containerWidth: CGFloat, containerHeight: CGFloat) -> CGRect {
        var rect: CGRect = .zero
        rect.size.width = containerWidth
        rect.size.height = containerHeight
        switch to {
            case .topLeft(let top, let left):
                rect.origin.x = left
                rect.origin.y = top
            case .topCenter(let top):
                rect.origin.x = (UIScreen.main.bounds.width - containerWidth) / 2.0
                rect.origin.y = top
            case .topRight(let top, let right):
                rect.origin.x = UIScreen.main.bounds.width - containerWidth - right
                rect.origin.y = top
            case .leftCenter(let left):
                rect.origin.x = left
                rect.origin.y = (UIScreen.main.bounds.height - containerHeight) / 2.0
            case .bottomLeft(let bottom, let left):
                rect.origin.x = left
                rect.origin.y = UIScreen.main.bounds.height - containerHeight - bottom
            case .bottomCenter(let bottom):
                rect.origin.x = (UIScreen.main.bounds.width - containerWidth) / 2.0
                rect.origin.y = UIScreen.main.bounds.height - containerHeight - bottom
            case .bottomRight(let bottom, let right):
                rect.origin.x = UIScreen.main.bounds.width - containerWidth - right
                rect.origin.y = UIScreen.main.bounds.height - containerHeight - bottom
            case .rightCenter(let right):
                rect.origin.x = UIScreen.main.bounds.width - containerWidth - right
                rect.origin.y = (UIScreen.main.bounds.height - containerHeight) / 2.0
            case .center:
                rect.origin.x = (UIScreen.main.bounds.width - containerWidth) / 2.0
                rect.origin.y = (UIScreen.main.bounds.height - containerHeight) / 2.0
        }
        return rect
    }
}

extension GLAlert {
    private func setInitialViewConstraints(view: UIView?, from: GLAlertFromPosition, isRemake: Bool) {
        guard let view = view else { return }
        guard let superview = view.superview else { return }
        switch from {
            case .topLeft(let bottom, let left):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.left.equalToSuperview().offset(left)
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.left.equalToSuperview().offset(left)
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                }
            case .topCenter(let bottom):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                }
            case .topRight(let bottom, let right):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.right.equalToSuperview().offset(-right)
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.right.equalToSuperview().offset(-right)
                        make.bottom.equalTo(superview.snp.top).offset(-bottom)
                    })
                }
            case .leftTop(let right, let top):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.top.equalToSuperview().offset(top)
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.top.equalToSuperview().offset(top)
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                }
            case .leftCenter(let right):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.centerY.equalToSuperview()
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.centerY.equalToSuperview()
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                }
            case .leftBottom(let right, let bottom):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.bottom.equalToSuperview().offset(-bottom)
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.bottom.equalToSuperview().offset(-bottom)
                        make.right.equalTo(superview.snp.left).offset(-right)
                    })
                }
            case .bottomLeft(let top, let left):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.left.equalToSuperview().offset(left)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.left.equalToSuperview().offset(left)
                    })
                }
            case .bottomCenter(let top):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.centerX.equalToSuperview()
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.centerX.equalToSuperview()
                    })
                }
            case .bottomRight(let top, let right):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.right.equalToSuperview().offset(-right)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.right.equalToSuperview().offset(-right)
                    })
                }
            case .rightTop(let left, let top):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.top.equalTo(superview.snp.bottom).offset(top)
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                }
            case .rightCenter(let left):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                }
            case .rightBottom(let left, let bottom):
                if isRemake {
                    view.snp.remakeConstraints({ (make) in
                        make.bottom.equalToSuperview().offset(-bottom)
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                } else {
                    view.snp.makeConstraints({ (make) in
                        make.bottom.equalToSuperview().offset(-bottom)
                        make.left.equalTo(superview.snp.right).offset(left)
                    })
                }
            default:
                break
        }
    }
    
    private func setEndViewConstraints(view: UIView?, to: GLAlertDestinationPostion) {
        guard let view = view else { return }
        guard let _ = view.superview else { return }
        switch to {
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
}
