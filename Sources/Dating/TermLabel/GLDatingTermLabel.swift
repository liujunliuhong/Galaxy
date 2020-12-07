//
//  GLDatingTermLabel.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import YYText

public class GLDatingTermLabel: YYLabel {
    
    public var clickTermsOfServiceClosure: (()->Void)?
    public var clickPrivacyPolicyClosure: (()->Void)?
    
    public init(text: String?,
                termsOfUseString: String?,
                privacyPolicyString: String?,
                textColor: UIColor?,
                font: UIFont?,
                alignment: NSTextAlignment,
                linkTextColor: UIColor?,
                linkBackgroundColor: UIColor?,
                maxWidth: CGFloat) {
        super.init(frame: .zero)
        
        self.preferredMaxLayoutWidth = maxWidth
        self.numberOfLines = 0
        
        let text = text ?? ""
        let termsOfUseString = termsOfUseString ?? ""
        let privacyPolicyString = privacyPolicyString ?? ""
        
        let termsOfServiceRange = (text as NSString).range(of: termsOfUseString)
        let privacyPolicyRange = (text as NSString).range(of: privacyPolicyString)
        
        let atr = NSMutableAttributedString(string: text)
        atr.yy_font = font
        atr.yy_color = textColor
        atr.yy_alignment = alignment
        atr.yy_setColor(linkTextColor, range: termsOfServiceRange)
        atr.yy_setUnderlineStyle(.single, range: termsOfServiceRange)
        atr.yy_setUnderlineColor(linkTextColor, range: termsOfServiceRange)
        atr.yy_setColor(linkTextColor, range: privacyPolicyRange)
        atr.yy_setUnderlineStyle(.single, range: privacyPolicyRange)
        atr.yy_setUnderlineColor(linkTextColor, range: privacyPolicyRange)
        
        atr.yy_setTextHighlight(termsOfServiceRange, color: linkTextColor, backgroundColor: linkBackgroundColor) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.clickTermsOfServiceClosure?()
        }
        atr.yy_setTextHighlight(privacyPolicyRange, color: linkTextColor, backgroundColor: linkBackgroundColor) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.clickPrivacyPolicyClosure?()
        }
        
        self.attributedText = atr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
