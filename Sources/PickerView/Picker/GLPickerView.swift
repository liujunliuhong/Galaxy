//
//  GLPickerView.swift
//  PickerView
//
//  Created by galaxy on 2020/10/25.
//

import UIKit

public typealias GLPickerDoneClosure = ([Int])->()

open class GLPickerView: UIView {
    
    deinit {
        #if DEBUG
        //print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        self.removeNotification()
    }
    
    /// 数据源。数据源的设置要在其他属性设置的最前面
    open var titlesForComponents: [[String]]? {
        didSet {
            if self.attributeTitlesForComponents == nil && self.titlesForComponents != nil {
                self.currentSelectIndexs.removeAll()
                for _ in 0..<self.titlesForComponents!.count {
                    self.currentSelectIndexs.append(0)
                }
                self.currentSelectRowClosure?(self.currentSelectIndexs)
            }
        }
    }
    
    /// 富文本数据源，优先级最高。数据源的设置要在其他属性设置的最前面
    open var attributeTitlesForComponents: [[NSAttributedString]]? {
        didSet {
            if self.attributeTitlesForComponents != nil {
                self.currentSelectIndexs.removeAll()
                for _ in 0..<self.attributeTitlesForComponents!.count {
                    self.currentSelectIndexs.append(0)
                }
                self.currentSelectRowClosure?(self.currentSelectIndexs)
            }
        }
    }
    
    /// 文本颜色，当`titlesForComponents`不为空时，有效
    open var titleColor: UIColor = .black
    
    /// 文本字体，当`titlesForComponents`不为空时，有效
    open var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /// 分割线颜色(iOS 14之后，UIPickerView没有分割线了，取而代之的是显示在中间的一个选中背景view)
    open var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
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
    
    /// 工具栏高度
    open var toolBarHeight: CGFloat = 49.0
    
    /// pickerView
    open lazy private(set) var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    
    /// pickerView实时变化的回调
    public var currentSelectRowClosure: (([Int])->())?
    
    /// 手动触发pickerView滚动结束后的回调
    public var didSelectRowClosure: ((Int, Int)->())?
    
    private var sumHeight: CGFloat = 0.0
    private var doneClosure: GLPickerDoneClosure?
    private var currentSelectIndexs: [Int] = []
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0)
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
        
        init?(rawValue: GLPickerView.ColorType.RawValue) {
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
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
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
}


extension GLPickerView {
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
extension GLPickerView {
    /// 刷新所有列
    @objc open func reloadAllComponents() {
        self.pickerView.reloadAllComponents()
    }
    
    /// 刷新某一列
    @objc open func reload(component: Int) {
        pickerView.reloadComponent(component)
    }
    
    /// 选中某一列的某一行。该方法不会执行`didSelectRow`方法。已经对`row`和`component`进行了纠错处理
    @objc open func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        var row = row
        var component = component
        if component < 0 {
            component = 0
        } else if let attributeTitlesForComponents = self.attributeTitlesForComponents, component >= attributeTitlesForComponents.count {
            component = attributeTitlesForComponents.count - 1
        } else if let titlesForComponents = self.titlesForComponents, component >= titlesForComponents.count {
            component = titlesForComponents.count - 1
        }
        
        if let attributeTitlesForComponents = self.attributeTitlesForComponents {
            let rows = attributeTitlesForComponents[component]
            if row < 0 {
                row = 0
            } else if row >= rows.count {
                row = rows.count - 1
            }
        } else if let titlesForComponents = self.titlesForComponents {
            let rows = titlesForComponents[component]
            if row < 0 {
                row = 0
            } else if row >= rows.count {
                row = rows.count - 1
            }
        }
        
        if self.titlesForComponents == nil && self.attributeTitlesForComponents == nil {
            return
        }
        if let attributeTitlesForComponents = self.attributeTitlesForComponents, attributeTitlesForComponents.count <= 0 {
            return
        } else if let titlesForComponents = self.titlesForComponents, titlesForComponents.count <= 0 {
            return
        }
        
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
        if component <= self.currentSelectIndexs.count {
            self.currentSelectIndexs[component] = row
        }
        self.currentSelectRowClosure?(self.currentSelectIndexs)
    }
    
    
    /// 显示`GLPickerView`
    @objc open func show(doneClosure: GLPickerDoneClosure?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
//        if self.titlesForComponents == nil && self.attributeTitlesForComponents == nil {
//            return
//        }
//        if let attributeTitlesForComponents = self.attributeTitlesForComponents, attributeTitlesForComponents.count <= 0 {
//            return
//        } else if let titlesForComponents = self.titlesForComponents, titlesForComponents.count <= 0 {
//            return
//        }
        
        self.doneClosure = doneClosure
        
        window.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.gestureView)
        self.backgroundView.addSubview(self)
        self.addSubview(self.toolBar == nil ? self.defaultToolBar : self.toolBar!)
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
        
        self.defaultToolBar.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.defaultToolBar.sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        self.currentSelectRowClosure?(self.currentSelectIndexs)
    }
    
    
    /// 隐藏`GLPickerView`
    @objc open func dismiss() {
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
    @objc open func getResult() {
        var results: [Int] = []
        for component in 0..<self.pickerView.numberOfComponents {
            let selectRow = self.pickerView.selectedRow(inComponent: component)
            results.append(selectRow)
        }
        self.currentSelectIndexs = results
        self.currentSelectRowClosure?(self.currentSelectIndexs)
        self.doneClosure?(results)
    }
}

// MARK: - 事件
extension GLPickerView {
    @objc private func sureAction() {
        self.getResult()
        self.dismiss()
    }
    
    @objc private func cancelAction() {
        self.dismiss()
    }
    
    @objc private func tapAction() {
        self.dismiss()
    }
}

// MARK: - 通知
extension GLPickerView {
    @objc private func statusBarOrientationNotification() {
        self.updateFrame()
    }
}

// MARK: - 私有方法
extension GLPickerView {
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
        var _toolBar: UIView = self.defaultToolBar
        if self.toolBar != nil {
            _toolBar = self.toolBar!
        }
        _toolBar.frame = CGRect(x: 0,
                                y: 0,
                                width: self.frame.width,
                                height: self.toolBarHeight)
        self.pickerView.frame = CGRect(x: 0,
                                       y: self.toolBarHeight,
                                       width: self.frame.width,
                                       height: self.pickerView.frame.height)
    }
}


// MARK: - 代理 && 数据源
extension GLPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
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


/*
 private let titles: [[String]] = [["0 - 0",
                                    "0 - 1",
                                    "0 - 2",
                                    "0 - 3",
                                    "0 - 4",
                                    "0 - 5"],
                                   ["1 - 0",
                                    "1 - 1",
                                    "1 - 2",
                                    "1 - 3"]]
 
 let pickerView = GLPickerView()
 pickerView.titlesForComponents = titles
 pickerView.defaultToolBar.titleLabel.text = "普通PickerView"
 pickerView.selectRow(1, inComponent: 0, animated: false)
 pickerView.selectRow(2, inComponent: 1, animated: false)
 pickerView.show { (selectIndexs) in
     print("selectIndexs: \(selectIndexs)")
 }
 */














/*
 class CustomToolBar: UIView {
     lazy var titleLabel: UILabel = {
         let titleLabel = UILabel()
         titleLabel.font = UIFont.systemFont(ofSize: 15)
         titleLabel.textColor = .black
         titleLabel.textAlignment = .center
         return titleLabel
     }()
     
     lazy var button: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("确定", for: .normal)
         button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
         return button
     }()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         setupUI()
     }
     init() {
         super.init(frame: .zero)
         setupUI()
     }
     
     var sureClosure: (()->())?
     
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     func setupUI() {
         self.backgroundColor = .cyan
         self.addSubview(self.titleLabel)
         self.addSubview(self.button)
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         self.titleLabel.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
         self.titleLabel.bounds = CGRect(x: 0, y: 0, width: 200, height: 40)
         
         self.button.frame = CGRect(x: self.bounds.width - 10 - 80, y: 0, width: 80, height: self.bounds.height)
     }
     
     @objc func sureAction() {
         self.sureClosure?()
     }
 }


 let pickerView = GLPickerView()
 pickerView.titlesForComponents = titles
 pickerView.toolBar = self.customToolBar // 使用自定义的`toolBar`
 pickerView.toolBarHeight = 49.0 // 修改`toolBar`高度
 pickerView.selectRow(1, inComponent: 0, animated: false)
 pickerView.selectRow(2, inComponent: 1, animated: false)
 // 实时变化回调
 pickerView.currentSelectRowClosure = { [weak self] (currentSelectIndexs) in
     guard let self = self else { return }
     var string: String = ""
     for (component, row) in currentSelectIndexs.enumerated() {
         string += titles[component][row]
         if currentSelectIndexs.count > 1 && component < currentSelectIndexs.count - 1 {
             string += "，"
         }
     }
     print("\(string)")
     self.customToolBar.titleLabel.text = "实时变化: \(string)"
 }
 pickerView.show { (selectIndexs) in
     print("selectIndexs: \(selectIndexs)")
 }

 DispatchQueue.main.asyncAfter(deadline: .now() + 1) { /* 延迟1秒滚动到指定的行 */
     pickerView.selectRow(5, inComponent: 0, animated: true)
     pickerView.selectRow(1, inComponent: 1, animated: true)
 }

 self.customToolBar.sureClosure = { [weak pickerView] in
     pickerView?.getResult()
     pickerView?.dismiss()
 }
 
 */
