//
//  GLDatingTextField.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

public class GLDatingTextField: UIView {
    
    private var _placeholderFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    private var _placeholderColor: UIColor = UIColor.gl_color(string: "#AAAAAA")
    private var _placeholder = ""
    
    public private(set) lazy var textField: _TextField = {
        let textField = _TextField()
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textColor = UIColor.gl_color(string: "#ffffff")
        textField.tintColor = UIColor.gl_color(string: "#ffffff")
        return textField
    }()
    
    /// 占位文本
    public var placeholder: String? {
        didSet {
            _placeholder = placeholder ?? ""
            self.reloadPlaceHolder()
        }
    }
    
    /// 占位文本字体
    public var placeholderFont: UIFont? {
        didSet {
            _placeholderFont = placeholderFont ?? _placeholderFont
            self.reloadPlaceHolder()
        }
    }
    
    /// 占位文本颜色
    public var placeholderColor: UIColor? {
        didSet {
            _placeholderColor = placeholderColor ?? _placeholderColor
            self.reloadPlaceHolder()
        }
    }
    
    /// 默认文本
    public var defaultText: String? {
        didSet {
            self.textField.text = defaultText
            self.currentText.accept(defaultText)
        }
    }
    
    /// 是否可以选中
    public var shouldSelect: Bool = true {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 选中时边框宽度
    public var selectBorderWidth: CGFloat = 1.5 {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 选中时边框颜色
    public var selectBorderColor: UIColor? {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 当可以选中时，正常状态下边框宽度
    public var shouldSelectNormalBorderWidth: CGFloat = 0 {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 当可以选中时，正常状态下边框颜色
    public var shouldSelectNormalBorderColor: UIColor? {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 正常状态下边框宽度
    public var normalBorderWidth: CGFloat = 1.5 {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 正常状态下边框颜色
    public var normalBorderColor: UIColor? {
        didSet {
            self.reloadUI()
        }
    }
    
    /// 圆角
    public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.reloadUI()
        }
    }
    
    
    /// 实时文本变化回调，监听此值的变化
    public let currentText = BehaviorRelay<String?>(value: nil)
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
        bindViewModel()
    }
    
    public init() {
        super.init(frame: .zero)
        initUI()
        setupUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.frame = self.bounds
    }
}

extension GLDatingTextField {
    private func initUI() {
        self.layer.masksToBounds = true
        self.backgroundColor = .gl_clear
    }
    
    private func setupUI() {
        self.addSubview(self.textField)
    }
    
    private func bindViewModel() {
        self.reloadUI()
        
        self.currentText.subscribe(onNext: { [weak self] (text) in
            guard let self = self else { return }
            self.reloadUI()
        }).disposed(by: rx.disposeBag)
        
        self.textField.rx.text
            .bind(to: self.currentText)
            .disposed(by: rx.disposeBag)
    }
    
    private func reloadPlaceHolder() {
        let atr = NSMutableAttributedString(string: _placeholder, attributes: [.foregroundColor: _placeholderColor, .font: _placeholderFont])
        self.textField.attributedPlaceholder = atr
    }
    
    private func reloadUI() {
        self.layer.cornerRadius = self.cornerRadius
        let text = self.currentText.value ?? ""
        if self.shouldSelect {
            if text.count > 0 {
                self.layer.borderColor = self.selectBorderColor?.cgColor
                self.layer.borderWidth = self.selectBorderWidth
            } else {
                self.layer.borderColor = self.shouldSelectNormalBorderColor?.cgColor
                self.layer.borderWidth = self.shouldSelectNormalBorderWidth
            }
        } else {
            self.layer.borderColor = self.normalBorderColor?.cgColor
            self.layer.borderWidth = self.normalBorderWidth
        }
    }
}

public class _TextField: UITextField {
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
}

extension _TextField {
    private func contentRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10.0, y: bounds.origin.y, width: bounds.size.width - 10.0*2.0, height: bounds.size.height)
    }
}
