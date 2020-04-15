//
//  YHPickerView.swift
//  FNDating
//
//  Created by apple on 2019/10/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

public class YHPickerView: UIView {

    deinit {
        YHDebugLog("\(self.classForCoder) deinit")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    
    /// 数据源
    public var titlesForComponents: [[String]]?
    
    /// 富文本数据源
    public var attributeTitlesForComponents: [[NSAttributedString]]?
    
    /// 每列文字颜色(富文本数据源会覆盖此属性)
    public var titleColor: UIColor = .black
    
    /// 每列文字字体(富文本数据源会覆盖此属性)
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
    
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
    
    
    
    
    
    
    
    
    
    
    /// toolBar高度
    private let toolBarHeight: CGFloat = 49.0
    
    /// picker高度
    private var pickerHeight: CGFloat = 0.0
    
    /// 完成回调
    private var doneClosure: (([Int])->())?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
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
        
        init?(rawValue: YHPickerView.colorType.RawValue) {
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.pickerView.subviews.forEach { (view) in
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


extension YHPickerView {
    private func setup() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationNotification), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        
        backgroundColor = .white
    }
}


extension YHPickerView {
    
    /// 刷新整个pickerView
    public func reloadAllComponents() {
        pickerView.reloadAllComponents()
    }
    
    /// 刷新某列
    /// - Parameter component: component
    public func reload(component: Int) {
        pickerView.reloadComponent(component)
    }
    
    /// 设置选中的行
    /// - Parameter indexs: indexs
    /// - Parameter animation: animation
    public func setSelect(indexs: [Int], animation: Bool) {
        assert(indexs.count == pickerView.numberOfComponents, "indexs和pickerView的components数目不一致")
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            for (component, index) in indexs.enumerated() {
                let items = attributeTitlesForComponents[component]
                assert(index <= items.count - 1, "数组越界")
                pickerView.selectRow(index, inComponent: component, animated: animation)
            }
        }
        if let titlesForComponents = titlesForComponents {
            for (component, index) in indexs.enumerated() {
                let items = titlesForComponents[component]
                assert(index <= items.count - 1, "数组越界")
                pickerView.selectRow(index, inComponent: component, animated: animation)
            }
        }
    }
    
    /// show
    /// - Parameter doneClosure: 点击完成按钮之后的回调
    public func show(doneClosure: (([Int])->())?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if titlesForComponents == nil && attributeTitlesForComponents == nil {
            return
        }
        
        self.doneClosure = doneClosure
        
        window.addSubview(backgroundView)
        backgroundView.addSubview(gestureView)
        backgroundView.addSubview(self)
        addSubview(toolBar)
        addSubview(pickerView)
        
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
}

extension YHPickerView {
    
    /// dismiss
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
    
    /// done
    @objc public func done() {
        var results: [Int] = []
        for component in 0..<pickerView.numberOfComponents {
            let selectRow = pickerView.selectedRow(inComponent: component)
            results.append(selectRow)
        }
        self.doneClosure?(results)
        dismiss()
    }
}

extension YHPickerView {
    @objc private func dismissTap() {
        dismiss()
    }
    
    @objc private func statusBarOrientationNotification() {
        updateFrame()
    }
}

extension YHPickerView {
    private func updateFrame() {
        backgroundView.frame = UIScreen.main.bounds
        gestureView.frame = UIScreen.main.bounds
        
        pickerView.sizeToFit()
        
        let height = toolBarHeight + UIDevice.YH_HomeIndicator_Height + pickerView.YH_Height
        
        self.pickerHeight = height
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - height, width: UIScreen.main.bounds.size.width, height: height)
        toolBar.frame = CGRect(x: 0, y: 0, width: self.YH_Width, height: toolBarHeight)
        pickerView.frame = CGRect(x: 0, y: toolBarHeight, width: self.YH_Width, height: pickerView.YH_Height)
    }
}



extension YHPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let titlesForComponents = titlesForComponents {
            return titlesForComponents.count
        }
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            return attributeTitlesForComponents.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let titlesForComponents = titlesForComponents {
            return titlesForComponents[component].count
        }
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            return attributeTitlesForComponents[component].count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            let attributeString = attributeTitlesForComponents[component][row]
            label.attributedText = attributeString
        }
        if let titlesForComponents = titlesForComponents {
            let title = titlesForComponents[component][row]
            label.textAlignment = .center
            label.textColor = titleColor
            label.font = titleFont
            label.text = title
            label.adjustsFontSizeToFitWidth = true
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
