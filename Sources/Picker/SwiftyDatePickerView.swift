//
//  SwiftyDatePickerView.swift
//  SwiftTool
//
//  Created by liujun on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public typealias SwiftyDatePickerDoneClosure = (Date) -> ()

public class SwiftyDatePickerView: UIView {
    
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        self.removeNotification()
    }
    
    /// separator line color
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    /// toolBar.   Please set relevant attributes yourself
    public lazy var toolBar: SwiftyPickerToolBar = {
        let toolBar = SwiftyPickerToolBar()
        return toolBar
    }()
    
    /// datePickerView.  Please set relevant attributes yourself
    public lazy private(set) var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        return datePickerView
    }()
    
    /// toolBar height
    public var toolBarHeight: CGFloat = 49.0
    
    /// sum height
    public private(set) var sumHeight: CGFloat = 0.0
    
    
    private var doneClosure: SwiftyDatePickerDoneClosure?
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        return backgroundView
    }()
    
    private lazy var gestureView: UIView = {
        let gestureView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
        gestureView.addGestureRecognizer(tapGesture)
        return gestureView
    }()
    
    private enum ColorType: RawRepresentable {
        case clear
        case blackTransparent
        
        typealias RawValue = UIColor
        
        var rawValue: UIColor {
            switch self {
            case .clear:
                return .clear
            case .blackTransparent:
                return UIColor.black.withAlphaComponent(0.4)
            }
        }
        
        init?(rawValue: SwiftyDatePickerView.ColorType.RawValue) {
            switch rawValue {
            case ColorType.clear.rawValue:
                self = .clear
            case ColorType.blackTransparent.rawValue:
                self = .blackTransparent
            default:
                return nil
            }
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.datePickerView.subviews.forEach { (view) in
            if view.isKind(of: UIPickerView.classForCoder()) {
                view.subviews.forEach({ (view1) in
                    if view1.frame.height.isLessThanOrEqualTo(1.0) {
                        view1.backgroundColor = self.separatorLineColor
                    }
                })
            }
        }
    }
}

extension SwiftyDatePickerView {
    private func setup() {
        self.backgroundColor = .white
        self.removeNotification()
        self.addNotification()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationNotification), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
}

extension SwiftyDatePickerView {
    
    /// show
    /// - Parameter doneClosure: 点击完成按钮之后的回调
    public func show(doneClosure: SwiftyDatePickerDoneClosure?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.doneClosure = doneClosure
        
        window.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.gestureView)
        self.backgroundView.addSubview(self)
        self.addSubview(toolBar)
        self.addSubview(datePickerView)
        
        self.updateFrame()
        
        self.gestureView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        self.gestureView.backgroundColor = ColorType.clear.rawValue
        self.transform = CGAffineTransform(translationX: 0, y: self.sumHeight)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
            self.gestureView.backgroundColor = ColorType.blackTransparent.rawValue
        }) { (_) in
            self.gestureView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        }
        
        self.toolBar.cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.toolBar.sureButton.addTarget(self, action: #selector(done), for: .touchUpInside)
    }
}

// MARK: - action
extension SwiftyDatePickerView {
    @objc public func dismiss() {
        
        self.gestureView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        self.gestureView.backgroundColor = ColorType.blackTransparent.rawValue
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.sumHeight)
            self.gestureView.backgroundColor = ColorType.clear.rawValue
        }) { (_) in
            self.gestureView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
            
            self.removeFromSuperview()
            self.gestureView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            self.removeNotification()
        }
    }
    
    @objc public func done() {
        self.doneClosure?(self.datePickerView.date)
        self.dismiss()
    }
    
    @objc private func dismissTap() {
        self.dismiss()
    }
}

// MARK: - notification action
extension SwiftyDatePickerView {
    @objc private func statusBarOrientationNotification() {
        self.updateFrame()
    }
}

extension SwiftyDatePickerView {
    private func updateFrame() {
        self.backgroundView.frame = UIScreen.main.bounds
        self.gestureView.frame = UIScreen.main.bounds
        
        self.datePickerView.sizeToFit()
        
        let sumHeight = self.toolBarHeight + self.datePickerView.frame.height
        
        self.sumHeight = sumHeight
        
        self.frame = CGRect(x: 0,
                            y: UIScreen.main.bounds.size.height - sumHeight,
                            width: UIScreen.main.bounds.size.width,
                            height: sumHeight)
        self.toolBar.frame = CGRect(x: 0,
                                    y: 0,
                                    width: self.frame.width,
                                    height: self.toolBarHeight)
        self.datePickerView.frame = CGRect(x: 0,
                                           y: self.toolBarHeight,
                                           width: self.frame.width,
                                           height: self.datePickerView.frame.height)
    }
}
