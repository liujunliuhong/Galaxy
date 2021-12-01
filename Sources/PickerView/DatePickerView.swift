//
//  DatePickerView.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
public final class DatePickerView: UIView {
    deinit {
        removeNotification()
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    /// 分割线颜色
    ///
    /// `iOS 14`之后，`UIPickerView`没有分割线了，取而代之的是显示在中间的一个选中背景`view`
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
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
    
    /// `UIDatePicker`
    ///
    /// 请自行设置`UIDatePicker`属性
    public lazy private(set) var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) { /* iOS 13.4 之后新增加的属性。默认设置为`wheels`,否则界面显示有问题 */
            datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        return datePickerView
    }()
    
    /// 工具栏高度
    public var toolBarHeight: CGFloat = 49.0 {
        didSet {
            invalidateIntrinsicContentSize()
            AlertEngine.default.refresh()
            update()
        }
    }
    
    private var doneClosure: ((Date) -> ())?
    
    public override init(frame: CGRect) {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.4, *) {
            //
        } else {
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
    
    public override var intrinsicContentSize: CGSize {
        self.datePickerView.sizeToFit()
        let height = self.toolBarHeight + self.datePickerView.bounds.height
        
        return CGSize(width: GL.deviceWidth, height: height)
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension DatePickerView {
    private func setupUI() {
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // 白色
        if let toolBar = toolBar {
            addSubview(toolBar)
            addSubview(datePickerView)
            toolBar.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(toolBarHeight)
            }
            datePickerView.snp.makeConstraints { make in
                make.left.right.equalTo(toolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(toolBar.snp.bottom)
            }
        } else {
            addSubview(defaultToolBar)
            addSubview(datePickerView)
            defaultToolBar.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            datePickerView.snp.makeConstraints { make in
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
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension DatePickerView {
    
    /// 显示`DatePickerView`
    ///
    ///     let datePickerView = DatePickerView()
    ///     datePickerView.defaultToolBar.titleLabel.text = "DatePickerView"
    ///     datePickerView.datePickerView.minimumDate = Date().addingTimeInterval(-5*365*24*60*60) // 往前推5年
    ///     datePickerView.datePickerView.maximumDate = Date().addingTimeInterval(5*365*24*60*60) // 往后推5年
    ///     DatePickerView.show(pickerView: datePickerView) { selectDate in
    ///
    ///     }
    @available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
    public static func show(pickerView: DatePickerView, doneClosure: ((Date) -> ())?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        pickerView.doneClosure = doneClosure
        
        let options = AlertEngine.Options()
        options.fromPosition = .bottomCenter(top: .zero)
        options.toPosition = .bottomCenter(bottom: .zero)
        options.dismissPosition = .bottomCenter(top: .zero)
        options.translucentColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0.4)
        
        AlertEngine.default.show(parentView: window, alertView: pickerView, options: options)
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension DatePickerView {
    private func update() {
        if let toolBar = toolBar {
            toolBar.snp.remakeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            datePickerView.snp.remakeConstraints { make in
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
            datePickerView.snp.remakeConstraints { make in
                make.left.right.equalTo(defaultToolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(defaultToolBar.snp.bottom)
            }
        }
    }
    private func getResult() {
        self.doneClosure?(self.datePickerView.date)
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension DatePickerView {
    @objc private func orientationDidChange() {
        invalidateIntrinsicContentSize()
        update()
    }
    
    @objc private func cancelAction() {
        AlertEngine.default.dismiss()
    }
    
    @objc private func sureAction() {
        self.getResult()
        AlertEngine.default.dismiss()
    }
}
