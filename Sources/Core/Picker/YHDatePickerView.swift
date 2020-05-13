//
//  YHDatePickerView.swift
//  FNDating
//
//  Created by apple on 2019/9/11.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

public class YHDatePickerView: UIView {

    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    /// 分割线颜色
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    /// toolBar.  请自行设置相关属性
    public lazy var toolBar: YHPickerToolBar = {
        let toolBar = YHPickerToolBar()
        return toolBar
    }()
    
    /// datePickerView.  请自行设置相关属性
    public lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        return datePickerView
    }()
    
    
    
    
    
    
    
    /// toolBar高度
    private let toolBarHeight: CGFloat = 49.0
    
    /// picker高度
    private var pickerHeight: CGFloat = 0.0
    
    /// 完成回调
    private var doneClosure: ((Date)->())?
    
    /// 背景
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
        
        init?(rawValue: YHDatePickerView.ColorType.RawValue) {
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
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

extension YHDatePickerView {
    private func setup() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationNotification), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        
        backgroundColor = .white
    }
    
    private func addNotification() {
        
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
}

extension YHDatePickerView {
    
    /// show
    /// - Parameter doneClosure: 点击完成按钮之后的回调
    public func show(doneClosure: ((Date)->())?) {
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
        self.transform = CGAffineTransform(translationX: 0, y: self.pickerHeight)

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
    
    /// dismiss
    @objc public func dismiss() {
        
        self.gestureView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        self.gestureView.backgroundColor = ColorType.blackTransparent.rawValue
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.pickerHeight)
            self.gestureView.backgroundColor = ColorType.clear.rawValue
        }) { (_) in
            self.gestureView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
            
            self.removeFromSuperview()
            self.gestureView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        }
    }
    
    @objc public func done() {
        self.doneClosure?(self.datePickerView.date)
        self.dismiss()
    }
}

extension YHDatePickerView {
    @objc private func dismissTap() {
        self.dismiss()
    }
    
    @objc private func statusBarOrientationNotification() {
        self.updateFrame()
    }
}

extension YHDatePickerView {
    private func updateFrame() {
        self.backgroundView.frame = UIScreen.main.bounds
        self.gestureView.frame = UIScreen.main.bounds
        
        self.datePickerView.sizeToFit()
        
        let height = self.toolBarHeight + UIDevice.YH_HomeIndicator_Height + self.datePickerView.frame.height
        
        self.pickerHeight = height
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - height, width: UIScreen.main.bounds.size.width, height: height)
        self.toolBar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: toolBarHeight)
        self.datePickerView.frame = CGRect(x: 0, y: self.toolBarHeight, width: self.frame.width, height: self.datePickerView.frame.height)
    }
}
