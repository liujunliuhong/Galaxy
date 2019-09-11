//
//  YHDatePickerView.swift
//  FNDating
//
//  Created by apple on 2019/9/11.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHDatePickerView: UIView {

    deinit {
        YHDebugLog("\(self.classForCoder) deinit")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private let toolBarHeight: CGFloat = 49.0
    private var pickerHeight: CGFloat = 0.0
    
    private var doneClosure: ((Date)->())?
    
    
    public lazy var toolBar: YHPickerToolBar = {
        let toolBar = YHPickerToolBar()
        return toolBar
    }()
    
    
    /// date picker view.
    public lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        return datePickerView
    }()
    
    
    /// 背景
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        return backgroundView
    }()
    
    
    /// 分割线颜色
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private lazy var gestureView: UIView = {
        let gestureView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
        gestureView.addGestureRecognizer(tapGesture)
        return gestureView
    }()
    
    private enum colorType: RawRepresentable {
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
        
        init?(rawValue: FNRegisterSexView.colorType.RawValue) {
            switch rawValue {
            case colorType.clear.rawValue:
                self = .clear
            case colorType.blackTransparent.rawValue:
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.datePickerView.subviews.forEach { (view) in
            if view.isKind(of: UIPickerView.classForCoder()) {
                view.subviews.forEach({ (view1) in
                    if view1.YH_Height < 1 {
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
}

extension YHDatePickerView {
    @objc private func dismissTap() {
        dismiss()
    }
    
    @objc private func statusBarOrientationNotification() {
        updateFrame()
    }
}

extension YHDatePickerView {
    public func show(doneClosure: ((Date)->())?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.doneClosure = doneClosure
        
        window.addSubview(backgroundView)
        backgroundView.addSubview(gestureView)
        backgroundView.addSubview(self)
        addSubview(toolBar)
        addSubview(datePickerView)
        
     
        updateFrame()
        
        
        gestureView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        self.gestureView.backgroundColor = colorType.clear.rawValue
        self.transform = CGAffineTransform(translationX: 0, y: self.pickerHeight)

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
            self.gestureView.backgroundColor = colorType.blackTransparent.rawValue
        }) { (_) in
            self.gestureView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        }
        
        
        toolBar.cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        toolBar.sureButton.addTarget(self, action: #selector(done), for: .touchUpInside)
    }
    
    private func updateFrame() {
        backgroundView.frame = UIScreen.main.bounds
        gestureView.frame = UIScreen.main.bounds
        
        datePickerView.sizeToFit()
        
        let height = toolBarHeight + UIDevice.YH_HomeIndicator_Height + datePickerView.YH_Height
        
        self.pickerHeight = height
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - height, width: UIScreen.main.bounds.size.width, height: height)
        toolBar.frame = CGRect(x: 0, y: 0, width: self.YH_Width, height: toolBarHeight)
        datePickerView.frame = CGRect(x: 0, y: toolBarHeight, width: self.YH_Width, height: datePickerView.YH_Height)
    }
}

extension YHDatePickerView {
    @objc public func dismiss() {
        
        gestureView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        self.gestureView.backgroundColor = colorType.blackTransparent.rawValue
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.pickerHeight)
            self.gestureView.backgroundColor = colorType.clear.rawValue
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
        dismiss()
    }
}
