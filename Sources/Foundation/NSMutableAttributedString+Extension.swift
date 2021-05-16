//
//  NSMutableAttributedString+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText

extension NSMutableAttributedString {
    
    /// font
    @discardableResult
    public func gl_add(font: UIFont?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .font, value: font, range: range)
        return self
    }
    
    /// foregroundColor
    @discardableResult
    public func gl_add(textColor: UIColor?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: kCTForegroundColorAttributeName as NSAttributedString.Key, value: textColor?.cgColor, range: range)
        gl_addAttribute(key: .foregroundColor, value: textColor, range: range)
        return self
    }
    
    /// ligature
    @discardableResult
    public func gl_add(ligature: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .ligature, value: ligature, range: range)
        return self
    }
    
    /// kern
    @discardableResult
    public func gl_add(kern: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .kern, value: kern, range: range)
        return self
    }
    
    /// underlineColor
    @discardableResult
    public func gl_add(underlineColor: UIColor?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .underlineColor, value: underlineColor?.cgColor, range: range)
        return self
    }
    
    
    /// underlineStyle
    @discardableResult
    public func gl_add(underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .underlineStyle, value: underlineStyle.rawValue, range: range)
        return self
    }
    
    /// strikethroughColor
    @discardableResult
    public func gl_add(strikethroughColor: UIColor?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .strikethroughColor, value: strikethroughColor?.cgColor, range: range)
        return self
    }
    
    /// strikethroughStyle
    @discardableResult
    public func gl_add(strikethroughStyle: NSUnderlineStyle, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .strikethroughStyle, value: strikethroughStyle.rawValue, range: range)
        return self
    }
    
    /// strokeColor
    @discardableResult
    public func gl_add(strokeColor: UIColor?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: kCTStrokeColorAttributeName as NSAttributedString.Key, value: strokeColor?.cgColor, range: range)
        gl_addAttribute(key: .strokeColor, value: strokeColor, range: range)
        return self
    }
    
    /// strokeWidth
    @discardableResult
    public func gl_add(strokeWidth: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .strokeWidth, value: strokeWidth, range: range)
        return self
    }
    
    /// shadow
    @discardableResult
    public func gl_add(shadow: NSShadow?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .shadow, value: shadow, range: range)
        return self
    }
    
    /// textEffect
    @discardableResult
    public func gl_add(textEffect: String?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .textEffect, value: textEffect, range: range)
        return self
    }
    
    /// baselineOffset
    @discardableResult
    public func gl_add(baselineOffset: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .baselineOffset, value: baselineOffset, range: range)
        return self
    }
    
    /// obliqueness
    @discardableResult
    public func gl_add(obliqueness: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .obliqueness, value: obliqueness, range: range)
        return self
    }
    
    /// expansion
    @discardableResult
    public func gl_add(expansion: NSNumber?, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .expansion, value: expansion, range: range)
        return self
    }
}

extension NSMutableAttributedString {
    /// paragraphStyle
    @discardableResult
    public func gl_add(paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> Self {
        gl_addAttribute(key: .paragraphStyle, value: paragraphStyle, range: range)
        return self
    }
    
    /// alignment
    @discardableResult
    public func gl_add(alignment: NSTextAlignment, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.alignment = alignment
        }
        return self
    }
    
    /// lineSpacing
    @discardableResult
    public func gl_add(lineSpacing: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.lineSpacing = lineSpacing
        }
        return self
    }
    
    /// lineBreakMode（此方法慎用）
    ///
    /// 如果忽略`SwiftyLabel`中的`lineBreakMode`属性，而直接通过该方法设置富文本的`lineBreakMode`，最后只会显示一行
    /// 原因是`lineBreakMode`最后是设置到富文本的`NSParagraphStyle`段落样式的属性中。
    /// 当富文本中的`NSParagraphStyle`属性中的`lineBreakMode`值有意义，那么用`CTFramesetter`创建的`CTLine`就只会有一行
    @discardableResult
    public func gl_add(lineBreakMode: NSLineBreakMode, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.lineBreakMode = lineBreakMode
        }
        return self
    }
    
    /// paragraphSpacingBefore
    @discardableResult
    public func gl_add(paragraphSpacingBefore: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
        return self
    }
    
    /// paragraphSpacing
    @discardableResult
    public func gl_add(paragraphSpacing: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacing = paragraphSpacing
        }
        return self
    }
    
    /// firstLineHeadIndent
    @discardableResult
    public func gl_add(firstLineHeadIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.firstLineHeadIndent = firstLineHeadIndent
        }
        return self
    }
    
    /// headIndent
    @discardableResult
    public func gl_add(headIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.headIndent = headIndent
        }
        return self
    }
    
    /// tailIndent
    @discardableResult
    public func gl_add(tailIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.tailIndent = tailIndent
        }
        return self
    }
    
    /// minimumLineHeight
    @discardableResult
    public func gl_add(minimumLineHeight: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.minimumLineHeight = minimumLineHeight
        }
        return self
    }
    
    /// maximumLineHeight
    @discardableResult
    public func gl_add(maximumLineHeight: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.maximumLineHeight = maximumLineHeight
        }
        return self
    }
    
    /// lineHeightMultiple
    @discardableResult
    public func gl_add(lineHeightMultiple: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.lineHeightMultiple = lineHeightMultiple
        }
        return self
    }
    
    /// hyphenationFactor
    @discardableResult
    public func gl_add(hyphenationFactor: Float, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.hyphenationFactor = hyphenationFactor
        }
        return self
    }
    
    /// defaultTabInterval
    @discardableResult
    public func gl_add(defaultTabInterval: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.defaultTabInterval = defaultTabInterval
        }
        return self
    }
    
    /// tabStops
    @discardableResult
    public func gl_add(tabStops: [NSTextTab]?, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.tabStops = tabStops
        }
        return self
    }
    
    /// baseWritingDirection
    @discardableResult
    public func gl_add(baseWritingDirection: NSWritingDirection, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.baseWritingDirection = baseWritingDirection
        }
        return self
    }
    
    /// set paragraph style
    private func paragraphStyleSet(range: NSRange? ,closure: (NSMutableParagraphStyle)->()) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.enumerateAttribute(.paragraphStyle, in: _range, options: .longestEffectiveRangeNotRequired) { (value, subRange, _) in
            var _style: NSMutableParagraphStyle?
            if var value = value as? NSParagraphStyle {
                if CFGetTypeID(value) == CTParagraphStyleGetTypeID() {
                    value = NSParagraphStyle.gl_nsStyle(with: value as! CTParagraphStyle)
                }
                _style = value as? NSMutableParagraphStyle
            } else {
                _style = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
            }
            if let style = _style {
                closure(style)
                self.gl_add(paragraphStyle: style, range: subRange)
            }
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult
    public func gl_addAttribute(key: NSAttributedString.Key, value: Any?, range: NSRange? = nil) -> Self {
        let _range = (range == nil) ? NSRange(location: 0, length: length) : range!
        removeAttribute(key, range: _range)
        if let value = value {
            addAttribute(key, value: value, range: _range)
        }
        return self
    }
    
    @discardableResult
    public func gl_addAttributes(attributes: [NSAttributedString.Key: Any]?, range: NSRange? = nil) -> Self {
        let _range = (range == nil) ? NSRange(location: 0, length: length) : range!
        guard let attributes = attributes else { return self }
        setAttributes([:], range: _range)
        for atr in attributes {
            gl_addAttribute(key: atr.key, value: atr.value, range: _range)
        }
        return self
    }
}
