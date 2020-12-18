//
//  GLDatingRefundTextView.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit

internal class GLDatingRefundTextView: UITextView {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = (GLDatingRefundOptions?.textColor ?? .white).withAlphaComponent(0.6)
        label.backgroundColor = .gl_clear
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    var placeholder: String? {
        didSet {
            self.placeholderLabel.text = placeholder
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initUI()
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-10)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GLDatingRefundTextView.textViewTextDidChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textViewTextDidChange() {
        let isPlaceholderHidden = !text.isEmpty
        self.placeholderLabel.isHidden = isPlaceholderHidden
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
