//
//  GLDatingRefundTextField.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

internal class GLDatingRefundTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var placeholder: String? {
        didSet {
            let atr = NSMutableAttributedString(string: placeholder ?? "", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: (GLDatingRefundOptions?.textColor ?? .white).withAlphaComponent(0.6)])
            self.attributedPlaceholder = atr
        }
    }
    
    func initUI() {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = GLDatingRefundOptions?.buttonColor.cgColor
        self.layer.cornerRadius = 2.5
        self.layer.masksToBounds = true
        self.backgroundColor = .gl_clear
        self.tintColor = GLDatingRefundOptions?.textColor
        self.font = UIFont.systemFont(ofSize: 17)
        self.textColor = GLDatingRefundOptions?.textColor
        self.keyboardType = .twitter
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.contentRect(forBounds: bounds)
    }
    private func contentRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10.0, y: bounds.origin.y, width: bounds.size.width - 10.0*2.0, height: bounds.size.height)
    }
}
