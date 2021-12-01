//
//  PickerView.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
public final class PickerView: UIView {
    deinit {
        removeNotification()
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    /// 数据源
    ///
    /// 数据源的设置要在其他属性设置的最前面
    public var titlesForComponents: [[String]]?
    
    /// 富文本数据源
    ///
    /// 优先级最高。数据源的设置要在其他属性设置的最前面
    public var attributeTitlesForComponents: [[NSAttributedString]]?
    
    /// 文本颜色
    ///
    /// 当`titlesForComponents`不为空时，有效
    public var titleColor: UIColor = .black
    
    /// 文本字体
    ///
    /// 当`titlesForComponents`不为空时，有效
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /// 分割线颜色
    ///
    /// `iOS 14`之后，`UIPickerView`没有分割线了，取而代之的是显示在中间的一个选中背景`view`
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// `toolBar`
    ///
    /// 可以传入自定义的`view`，当为`nil`时，将使用`defaultToolBar`
    public var toolBar: UIView?
    
    /// 框架默认的`toolBar`
    public private(set) lazy var defaultToolBar: PickerToolBar = {
        let toolBar = PickerToolBar()
        return toolBar
    }()
    
    /// 工具栏高度
    public var toolBarHeight: CGFloat = 49.0 {
        didSet {
            invalidateIntrinsicContentSize()
            AlertEngine.default.refresh()
            update()
        }
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    
    /// `UIPickerView`实时变化的回调
    private var currentSelectRowClosure: (([Int])->())? {
        didSet {
            self.currentSelectRowClosure?(self.currentSelectIndexs)
        }
    }
    
    /// 手动触发`UIPickerView`滚动结束停止后的回调
    private var didSelectRowClosure: ((Int, Int)->())?
    
    
    //
    private var doneClosure: (([Int])->())?
    //
    private var currentSelectIndexs: [Int] = []
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        setupUI()
        addAction()
    }
    
    public init() {
        super.init(frame: .zero)
        addNotification()
        setupUI()
        addAction()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.4, *) {
            //
        } else {
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
    
    public override var intrinsicContentSize: CGSize {
        self.pickerView.sizeToFit()
        let height = self.toolBarHeight + self.pickerView.bounds.height
        
        return CGSize(width: GL.deviceWidth, height: height)
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension PickerView {
    private func setupUI() {
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // 白色
        if let toolBar = toolBar {
            addSubview(toolBar)
            addSubview(pickerView)
            toolBar.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.makeConstraints { make in
                make.left.right.equalTo(toolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(toolBar.snp.bottom)
            }
        } else {
            addSubview(defaultToolBar)
            addSubview(pickerView)
            defaultToolBar.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.makeConstraints { make in
                make.left.right.equalTo(defaultToolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(defaultToolBar.snp.bottom)
            }
        }
    }
    
    private func addAction() {
        self.defaultToolBar.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.defaultToolBar.sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func getResult() {
        var results: [Int] = []
        for component in 0..<self.pickerView.numberOfComponents {
            let selectRow = self.pickerView.selectedRow(inComponent: component)
            results.append(selectRow)
        }
        self.currentSelectIndexs = results
        self.currentSelectRowClosure?(self.currentSelectIndexs)
        self.doneClosure?(results)
    }
    
    private func update() {
        if let toolBar = toolBar {
            toolBar.snp.remakeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.remakeConstraints { make in
                make.left.right.equalTo(toolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(toolBar.snp.bottom)
            }
        } else {
            defaultToolBar.snp.remakeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.remakeConstraints { make in
                make.left.right.equalTo(defaultToolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(defaultToolBar.snp.bottom)
            }
        }
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension PickerView {
    /// 刷新所有列
    public func reloadAllComponents() {
        pickerView.reloadAllComponents()
    }
    
    /// 刷新某一列
    public func reload(component: Int) {
        pickerView.reloadComponent(component)
    }
    
    /// 选中某一列的某一行
    ///
    /// 该方法不会执行`didSelectRow`方法。已经对`row`和`component`进行了纠错处理
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        var row = row
        var component = component
        if component < 0 {
            component = 0
        } else if let attributeTitlesForComponents = attributeTitlesForComponents,
                  component >= attributeTitlesForComponents.count {
            component = attributeTitlesForComponents.count - 1
        } else if let titlesForComponents = titlesForComponents,
                  component >= titlesForComponents.count {
            component = titlesForComponents.count - 1
        }
        
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            let rows = attributeTitlesForComponents[component]
            if row < 0 {
                row = 0
            } else if row >= rows.count {
                row = rows.count - 1
            }
        } else if let titlesForComponents = titlesForComponents {
            let rows = titlesForComponents[component]
            if row < 0 {
                row = 0
            } else if row >= rows.count {
                row = rows.count - 1
            }
        }
        
        if self.titlesForComponents == nil && attributeTitlesForComponents == nil {
            return
        }
        if let attributeTitlesForComponents = attributeTitlesForComponents,
           attributeTitlesForComponents.count <= 0 {
            return
        } else if let titlesForComponents = titlesForComponents,
                  titlesForComponents.count <= 0 {
            return
        }
        
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
        
        if let attributeTitlesForComponents = attributeTitlesForComponents {
            if currentSelectIndexs.count < attributeTitlesForComponents.count {
                return
            }
        } else if let titlesForComponents = titlesForComponents {
            if currentSelectIndexs.count < titlesForComponents.count {
                return
            }
        }
        
        if component <= currentSelectIndexs.count {
            currentSelectIndexs[component] = row
        }
        currentSelectRowClosure?(currentSelectIndexs)
    }
    
    /// 显示`PickerView`
    ///
    ///     let titles: [[String]] = [["0 - 0",
    ///                                "0 - 1",
    ///                                "0 - 2",
    ///                                "0 - 3",
    ///                                "0 - 4",
    ///                                "0 - 5"],
    ///                                ["1 - 0",
    ///                                "1 - 1",
    ///                                "1 - 2",
    ///                                "1 - 3"]]
    ///     let pickerView = PickerView()
    ///     pickerView.titlesForComponents = titles
    ///     pickerView.defaultToolBar.titleLabel.text = "普通PickerView"
    ///     pickerView.selectRow(1, inComponent: 0, animated: false)
    ///     pickerView.selectRow(2, inComponent: 1, animated: false)
    ///     pickerView.show { (selectIndexs) in
    ///         print("selectIndexs: \(selectIndexs)")
    ///     }
    @available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
    public func show(doneClosure: (([Int])->())?, currentSelectRowClosure: (([Int])->())? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return }
        //
        if self.titlesForComponents == nil && self.attributeTitlesForComponents == nil {
            return
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents, attributeTitlesForComponents.count <= 0 {
            return
        } else if let titlesForComponents = self.titlesForComponents, titlesForComponents.count <= 0 {
            return
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            for component in 0..<attributeTitlesForComponents.count {
                currentSelectIndexs.append(0)
                selectRow(0, inComponent: component, animated: true)
            }
        } else if let titlesForComponents = self.titlesForComponents{
            for component in 0..<titlesForComponents.count {
                currentSelectIndexs.append(0)
                selectRow(0, inComponent: component, animated: true)
            }
        }
        //
        self.doneClosure = doneClosure
        self.currentSelectRowClosure = currentSelectRowClosure
        //
        let options = AlertEngine.Options()
        options.fromPosition = .bottomCenter(top: .zero)
        options.toPosition = .bottomCenter(bottom: .zero)
        options.dismissPosition = .bottomCenter(top: .zero)
        options.translucentColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0.4)
        //
        AlertEngine.default.show(parentView: window, alertView: self, options: options)
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension PickerView {
    @objc private func orientationDidChange() {
        invalidateIntrinsicContentSize()
        update()
    }
    
    @objc private func sureAction() {
        self.getResult()
        AlertEngine.default.dismiss()
    }
    
    @objc private func cancelAction() {
        AlertEngine.default.dismiss()
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension PickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            return attributeTitlesForComponents.count
        } else if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            return attributeTitlesForComponents[component].count
        } else if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents[component].count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            let attributeString = attributeTitlesForComponents[component][row]
            label.attributedText = attributeString
        } else if let titlesForComponents = self.titlesForComponents {
            let title = titlesForComponents[component][row]
            label.textAlignment = .center
            label.textColor = self.titleColor
            label.font = self.titleFont
            label.text = title
            label.adjustsFontSizeToFitWidth = true
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(" component:\(component) -- row: \(row)")
        if component <= self.currentSelectIndexs.count {
            self.currentSelectIndexs[component] = row
        }
        self.currentSelectRowClosure?(self.currentSelectIndexs)
        
        self.didSelectRowClosure?(component, row)
    }
}
