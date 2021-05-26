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

extension GL where Base: NSMutableAttributedString {
    
    /// font
    @discardableResult
    public func add(font: UIFont?, range: NSRange? = nil) -> Self {
        addAttribute(key: .font, value: font, range: range)
        return self
    }
    
    /// foregroundColor
    @discardableResult
    public func add(textColor: UIColor?, range: NSRange? = nil) -> Self {
        addAttribute(key: kCTForegroundColorAttributeName as NSAttributedString.Key, value: textColor?.cgColor, range: range)
        addAttribute(key: .foregroundColor, value: textColor, range: range)
        return self
    }
    
    /// ligature
    @discardableResult
    public func add(ligature: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .ligature, value: ligature, range: range)
        return self
    }
    
    /// kern
    @discardableResult
    public func add(kern: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .kern, value: kern, range: range)
        return self
    }
    
    /// underlineColor
    @discardableResult
    public func add(underlineColor: UIColor?, range: NSRange? = nil) -> Self {
        addAttribute(key: .underlineColor, value: underlineColor?.cgColor, range: range)
        return self
    }
    
    
    /// underlineStyle
    @discardableResult
    public func add(underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> Self {
        addAttribute(key: .underlineStyle, value: underlineStyle.rawValue, range: range)
        return self
    }
    
    /// strikethroughColor
    @discardableResult
    public func add(strikethroughColor: UIColor?, range: NSRange? = nil) -> Self {
        addAttribute(key: .strikethroughColor, value: strikethroughColor?.cgColor, range: range)
        return self
    }
    
    /// strikethroughStyle
    @discardableResult
    public func add(strikethroughStyle: NSUnderlineStyle, range: NSRange? = nil) -> Self {
        addAttribute(key: .strikethroughStyle, value: strikethroughStyle.rawValue, range: range)
        return self
    }
    
    /// strokeColor
    @discardableResult
    public func add(strokeColor: UIColor?, range: NSRange? = nil) -> Self {
        addAttribute(key: kCTStrokeColorAttributeName as NSAttributedString.Key, value: strokeColor?.cgColor, range: range)
        addAttribute(key: .strokeColor, value: strokeColor, range: range)
        return self
    }
    
    /// strokeWidth
    @discardableResult
    public func add(strokeWidth: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .strokeWidth, value: strokeWidth, range: range)
        return self
    }
    
    /// shadow
    @discardableResult
    public func add(shadow: NSShadow?, range: NSRange? = nil) -> Self {
        addAttribute(key: .shadow, value: shadow, range: range)
        return self
    }
    
    /// textEffect
    @discardableResult
    public func add(textEffect: String?, range: NSRange? = nil) -> Self {
        addAttribute(key: .textEffect, value: textEffect, range: range)
        return self
    }
    
    /// baselineOffset
    @discardableResult
    public func add(baselineOffset: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .baselineOffset, value: baselineOffset, range: range)
        return self
    }
    
    /// obliqueness
    @discardableResult
    public func add(obliqueness: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .obliqueness, value: obliqueness, range: range)
        return self
    }
    
    /// expansion
    @discardableResult
    public func add(expansion: NSNumber?, range: NSRange? = nil) -> Self {
        addAttribute(key: .expansion, value: expansion, range: range)
        return self
    }
}

extension GL where Base == NSMutableAttributedString {
    /// paragraphStyle
    @discardableResult
    public func add(paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> Self {
        addAttribute(key: .paragraphStyle, value: paragraphStyle, range: range)
        return self
    }
    
    /// alignment
    @discardableResult
    public func add(alignment: NSTextAlignment, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.alignment = alignment
        }
        return self
    }
    
    /// lineSpacing
    @discardableResult
    public func add(lineSpacing: CGFloat, range: NSRange? = nil) -> Self {
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
    public func add(lineBreakMode: NSLineBreakMode, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.lineBreakMode = lineBreakMode
        }
        return self
    }
    
    /// paragraphSpacingBefore
    @discardableResult
    public func add(paragraphSpacingBefore: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
        return self
    }
    
    /// paragraphSpacing
    @discardableResult
    public func add(paragraphSpacing: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacing = paragraphSpacing
        }
        return self
    }
    
    /// firstLineHeadIndent
    @discardableResult
    public func add(firstLineHeadIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.firstLineHeadIndent = firstLineHeadIndent
        }
        return self
    }
    
    /// headIndent
    @discardableResult
    public func add(headIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.headIndent = headIndent
        }
        return self
    }
    
    /// tailIndent
    @discardableResult
    public func add(tailIndent: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.tailIndent = tailIndent
        }
        return self
    }
    
    /// minimumLineHeight
    @discardableResult
    public func add(minimumLineHeight: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.minimumLineHeight = minimumLineHeight
        }
        return self
    }
    
    /// maximumLineHeight
    @discardableResult
    public func add(maximumLineHeight: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.maximumLineHeight = maximumLineHeight
        }
        return self
    }
    
    /// lineHeightMultiple
    @discardableResult
    public func add(lineHeightMultiple: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.lineHeightMultiple = lineHeightMultiple
        }
        return self
    }
    
    /// hyphenationFactor
    @discardableResult
    public func add(hyphenationFactor: Float, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.hyphenationFactor = hyphenationFactor
        }
        return self
    }
    
    /// defaultTabInterval
    @discardableResult
    public func add(defaultTabInterval: CGFloat, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.defaultTabInterval = defaultTabInterval
        }
        return self
    }
    
    /// tabStops
    @discardableResult
    public func add(tabStops: [NSTextTab]?, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.tabStops = tabStops
        }
        return self
    }
    
    /// baseWritingDirection
    @discardableResult
    public func add(baseWritingDirection: NSWritingDirection, range: NSRange? = nil) -> Self {
        paragraphStyleSet(range: range) { (style) in
            style.baseWritingDirection = baseWritingDirection
        }
        return self
    }
    
    /// set paragraph style
    private func paragraphStyleSet(range: NSRange? ,closure: (NSMutableParagraphStyle)->()) {
        let _range = (range == nil) ? NSRange(location: 0, length: base.length) : range!
        base.enumerateAttribute(.paragraphStyle, in: _range, options: .longestEffectiveRangeNotRequired) { (value, subRange, _) in
            var _style: NSMutableParagraphStyle?
            if var value = value as? NSParagraphStyle {
                if CFGetTypeID(value) == CTParagraphStyleGetTypeID() {
                    value = (value as! CTParagraphStyle).gl.nsStyle
                }
                _style = value as? NSMutableParagraphStyle
            } else {
                _style = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
            }
            if let style = _style {
                closure(style)
                add(paragraphStyle: style, range: subRange)
            }
        }
    }
}

extension GL where Base == NSMutableAttributedString {
    @discardableResult
    public func addAttribute(key: NSAttributedString.Key, value: Any?, range: NSRange? = nil) -> Self {
        let _range = (range == nil) ? NSRange(location: 0, length: base.length) : range!
        base.removeAttribute(key, range: _range)
        if let value = value {
            base.addAttribute(key, value: value, range: _range)
        }
        return self
    }
    
    @discardableResult
    public func addAttributes(attributes: [NSAttributedString.Key: Any]?, range: NSRange? = nil) -> Self {
        let _range = (range == nil) ? NSRange(location: 0, length: base.length) : range!
        guard let attributes = attributes else { return self }
        base.setAttributes([:], range: _range)
        for atr in attributes {
            addAttribute(key: atr.key, value: atr.value, range: _range)
        }
        return self
    }
}
