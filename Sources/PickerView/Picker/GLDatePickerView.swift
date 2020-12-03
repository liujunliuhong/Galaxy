//
//  GLDatePickerView.swift
//  PickerView
//
//  Created by galaxy on 2020/10/25.
//

import UIKit

public typealias GLDatePickerDoneClosure = (Date) -> ()

public class GLDatePickerView: UIView {
    
    deinit {
        #if DEBUG
        //print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        self.removeNotification()
    }
    
    /// 分割线颜色
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    /// toolBar，可以传入自定义的`view`，当为`nil`时，将使用`defaultToolBar`
    open var toolBar: UIView?
    
    /// 框架默认的toolBar
    public private(set) lazy var defaultToolBar: GLPickerToolBar = {
        let toolBar = GLPickerToolBar()
        return toolBar
    }()
    
    /// datePickerView，请自行设置`pickerView`属性
    public lazy private(set) var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) { /* iOS 13.4 之后新增加的属性。默认设置为`wheels`,否则不能选择时间*/
            datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        return datePickerView
    }()
    
    /// 工具栏高度
    public var toolBarHeight: CGFloat = 49.0
    
    /// sum height
    public private(set) var sumHeight: CGFloat = 0.0
    
    
    private var doneClosure: GLDatePickerDoneClosure?
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        return backgroundView
    }()
    
    private lazy var gestureView: UIView = {
        let gestureView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
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
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0)
                case .blackTransparent:
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0.4)
            }
        }
        
        init?(rawValue: GLDatePickerView.ColorType.RawValue) {
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
        self.setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setupUI()
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
}

extension GLDatePickerView {
    private func setupUI() {
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // 白色
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

// MARK: - 公共方法
extension GLDatePickerView {
    
    /// 显示`GLDatePickerView`
    public func show(doneClosure: GLDatePickerDoneClosure?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.doneClosure = doneClosure
        
        window.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.gestureView)
        self.backgroundView.addSubview(self)
        self.addSubview(self.toolBar == nil ? self.defaultToolBar : self.toolBar!)
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
        
        self.defaultToolBar.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.defaultToolBar.sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    /// 隐藏`GLDatePickerView`
    public func dismiss() {
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
    
    /// 获取结果
    public func getResult() {
        self.doneClosure?(self.datePickerView.date)
    }
}

// MARK: - 事件
extension GLDatePickerView {
    @objc public func cancelAction() {
        self.dismiss()
    }
    
    @objc public func sureAction() {
        self.getResult()
        self.dismiss()
    }
    
    @objc private func tapAction() {
        self.dismiss()
    }
}

// MARK: - 通知
extension GLDatePickerView {
    @objc private func statusBarOrientationNotification() {
        self.updateFrame()
    }
}

// MARK: - 私有方法
extension GLDatePickerView {
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
        var _toolBar: UIView = self.defaultToolBar
        if self.toolBar != nil {
            _toolBar = self.toolBar!
        }
        _toolBar.frame = CGRect(x: 0,
                                y: 0,
                                width: self.frame.width,
                                height: self.toolBarHeight)
        self.datePickerView.frame = CGRect(x: 0,
                                           y: self.toolBarHeight,
                                           width: self.frame.width,
                                           height: self.datePickerView.frame.height)
    }
}


/*
 let datePickerView = GLDatePickerView()
 datePickerView.defaultToolBar.titleLabel.text = "DatePickerView"
 datePickerView.datePickerView.minimumDate = Date().addingTimeInterval(-5*365*24*60*60) // 往前推5年
 datePickerView.datePickerView.maximumDate = Date().addingTimeInterval(5*365*24*60*60) // 往后推5年
 datePickerView.datePickerView.datePickerMode = .date
 if #available(iOS 13.4, *) { /* iOS 13.4 之后新增加的属性 */
     datePickerView.datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels // 最好设置为`wheels`,否则不能选择时间
 }
 datePickerView.show { (selectDate) in
     print("selectDate: \(selectDate)")
 }
 */
