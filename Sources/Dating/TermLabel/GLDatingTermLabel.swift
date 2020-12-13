//
//  GLDatingTermLabel.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

fileprivate class _TextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override var canBecomeFirstResponder: Bool {
        return false
    }
}

public class GLDatingTermLabel: UIView {
    
    private lazy var textView = _TextView()
    
    public var clickTermsOfServiceClosure: (() -> Void)?
    public var clickPrivacyPolicyClosure: (() -> Void)?
    
    private let atr: NSMutableAttributedString
    
    public init(text: String?,
                termsOfUseString: String?,
                privacyPolicyString: String?,
                textColor: UIColor?,
                font: UIFont?,
                alignment: NSTextAlignment,
                linkTextColor: UIColor?) {
        
        let text = text ?? ""
        let termsOfUseString = termsOfUseString ?? ""
        let privacyPolicyString = privacyPolicyString ?? ""
        
        let termsOfServiceRange = (text as NSString).range(of: termsOfUseString)
        let privacyPolicyRange = (text as NSString).range(of: privacyPolicyString)
        
        let atr = NSMutableAttributedString(string: text)
        atr.gl_atr
            .add(textColor: textColor)
            .add(font: font)
            .add(textColor: linkTextColor, range: termsOfServiceRange)
            .add(textColor: linkTextColor, range: privacyPolicyRange)
            .add(alignment: alignment)
            .addAttribute(key: .link, value: "useragreement://", range: termsOfServiceRange)
            .addAttribute(key: .link, value: "privacy://", range: privacyPolicyRange)
        self.atr = atr
        
        super.init(frame: .zero)
        
        self.textView.isUserInteractionEnabled = true
        self.textView.font = font
        self.textView.textColor = textColor
        self.textView.isEditable = false
        self.textView.isScrollEnabled = false
        self.textView.delegate = self
        self.textView.textContainerInset = .zero
        self.textView.backgroundColor = UIColor.clear
        self.textView.attributedText = self.atr
        if let linkTextColor = linkTextColor {
            self.textView.linkTextAttributes = [.foregroundColor: linkTextColor]
        }
        self.addSubview(self.textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.frame = self.bounds
        self.invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        let width: CGFloat = self.bounds.width
        let height: CGFloat = self.atr.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil).height + 1.0
        return CGSize(width: width, height: height)
    }
}

extension GLDatingTermLabel: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.handle(URL: URL)
        return true
    }
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.handle(URL: URL)
        return true
    }
    
    private func handle(URL: URL) {
        if URL.scheme == "useragreement" {
            #if DEBUG
            print("点击用户协议")
            #endif
            self.clickTermsOfServiceClosure?()
        } else if URL.scheme == "privacy" {
            #if DEBUG
            print("点击隐私协议")
            #endif
            self.clickPrivacyPolicyClosure?()
        }
    }
}
