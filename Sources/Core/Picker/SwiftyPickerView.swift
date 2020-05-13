//
//  SwiftyPickerView.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public typealias SwiftyPickerDoneClosure = ([Int])->()

public class SwiftyPickerView: UIView {
    
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        self.removeNotification()
    }
    
    /// data source
    public var titlesForComponents: [[String]]?
    
    /// rich text data source
    public var attributeTitlesForComponents: [[NSAttributedString]]?
    
    /// text color for each column (rich text data sources will override this property)
    public var titleColor: UIColor = .black
    
    /// text font for each column (rich text data sources will override this property)
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
    
    /// separator line color
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    /// toolBar.  Please set relevant attributes yourself
    public lazy var toolBar: SwiftyPickerToolBar = {
        let toolBar = SwiftyPickerToolBar()
        return toolBar
    }()
    
    /// toolBar height
    public var toolBarHeight: CGFloat = 49.0
    
    /// picker
    public lazy private(set) var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    
    
    
    
    
    
    
    private var sumHeight: CGFloat = 0.0
    private var doneClosure: SwiftyPickerDoneClosure?
    
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
        
        init?(rawValue: SwiftyPickerView.ColorType.RawValue) {
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
        self.pickerView.subviews.forEach { (view) in
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


extension SwiftyPickerView {
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


extension SwiftyPickerView {
    
    /// reload pickerView
    public func reloadAllComponents() {
        self.pickerView.reloadAllComponents()
    }
    
    /// reload component
    /// - Parameter component: component
    public func reload(component: Int) {
        pickerView.reloadComponent(component)
    }
    
    /// set selected rows
    /// - Parameters:
    ///   - indexs: indexs
    ///   - animation: animation
    public func setSelect(indexs: [Int], animation: Bool) {
        assert(indexs.count == pickerView.numberOfComponents, "`indexes` and `pickerView` have different numbers of components")
        
        if let titlesForComponents = titlesForComponents {
            for (component, index) in indexs.enumerated() {
                let items = titlesForComponents[component]
                assert(index <= items.count - 1, "Array out of bounds")
                self.selectRow(index, inComponent: component, animated: animation)
            }
        } else if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            for (component, index) in indexs.enumerated() {
                let items = attributeTitlesForComponents[component]
                assert(index <= items.count - 1, "Array out of bounds")
                self.selectRow(index, inComponent: component, animated: animation)
            }
        }
    }
    
    /// Selects a row in a specified component of the picker view.
    /// - Parameters:
    ///   - row: row
    ///   - component: component
    ///   - animated: animated
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
    }
    
    
    /// show
    /// - Parameter doneClosure: doneClosure
    public func show(doneClosure: SwiftyPickerDoneClosure?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        if titlesForComponents == nil && attributeTitlesForComponents == nil {
            #if DEBUG
            print("no data source")
            #endif
            return
        }
        
        self.doneClosure = doneClosure
        
        window.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.gestureView)
        self.backgroundView.addSubview(self)
        self.addSubview(self.toolBar)
        self.addSubview(self.pickerView)
        
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
extension SwiftyPickerView {
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
        var results: [Int] = []
        for component in 0..<self.pickerView.numberOfComponents {
            let selectRow = self.pickerView.selectedRow(inComponent: component)
            results.append(selectRow)
        }
        self.doneClosure?(results)
        self.dismiss()
    }
    
    @objc private func dismissTap() {
        self.dismiss()
    }
}

// MARK: - notification
extension SwiftyPickerView {
    @objc private func statusBarOrientationNotification() {
        self.updateFrame()
    }
}

extension SwiftyPickerView {
    private func updateFrame() {
        self.backgroundView.frame = UIScreen.main.bounds
        self.gestureView.frame = UIScreen.main.bounds
        
        self.pickerView.sizeToFit()
        
        let sumHeight = self.toolBarHeight + self.pickerView.frame.height
        
        self.sumHeight = sumHeight
        
        self.frame = CGRect(x: 0,
                            y: UIScreen.main.bounds.size.height - sumHeight,
                            width: UIScreen.main.bounds.size.width,
                            height: sumHeight)
        self.toolBar.frame = CGRect(x: 0,
                                    y: 0,
                                    width: self.frame.width,
                                    height: self.toolBarHeight)
        self.pickerView.frame = CGRect(x: 0,
                                       y: self.toolBarHeight,
                                       width: self.frame.width,
                                       height: self.pickerView.frame.height)
    }
}



extension SwiftyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents.count
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            return attributeTitlesForComponents.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents[component].count
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            return attributeTitlesForComponents[component].count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if let titlesForComponents = self.titlesForComponents {
            let title = titlesForComponents[component][row]
            label.textAlignment = .center
            label.textColor = self.titleColor
            label.font = self.titleFont
            label.text = title
            label.adjustsFontSizeToFitWidth = true
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            let attributeString = attributeTitlesForComponents[component][row]
            label.attributedText = attributeString
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(" component:\(component) -- row: \(row)")
    }
}

