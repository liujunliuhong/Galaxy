//
//  NSMutableAttributedString+GLExtension.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText

extension NSMutableAttributedString {
    /// font
    public func gl_add(font: UIFont?, range: NSRange? = nil) {
        gl_addAttribute(key: .font, value: font, range: range)
    }
    
    /// foregroundColor
    public func gl_add(textColor: UIColor?, range: NSRange? = nil) {
        gl_addAttribute(key: kCTForegroundColorAttributeName as NSAttributedString.Key, value: textColor?.cgColor, range: range)
        gl_addAttribute(key: .foregroundColor, value: textColor, range: range)
    }
    
    /// ligature
    public func gl_add(ligature: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .ligature, value: ligature, range: range)
    }
    
    /// kern
    public func gl_add(kern: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .kern, value: kern, range: range)
    }
    
    /// underlineColor
    public func gl_add(underlineColor: UIColor?, range: NSRange? = nil) {
        gl_addAttribute(key: .underlineColor, value: underlineColor?.cgColor, range: range)
    }
    
    
    /// underlineStyle
    public func gl_add(underlineStyle: NSUnderlineStyle, range: NSRange? = nil) {
        gl_addAttribute(key: .underlineStyle, value: underlineStyle.rawValue, range: range)
    }
    
    /// strikethroughColor
    public func gl_add(strikethroughColor: UIColor?, range: NSRange? = nil) {
        gl_addAttribute(key: .strikethroughColor, value: strikethroughColor?.cgColor, range: range)
    }
    
    /// strikethroughStyle
    public func gl_add(strikethroughStyle: NSUnderlineStyle, range: NSRange? = nil) {
        gl_addAttribute(key: .strikethroughStyle, value: strikethroughStyle.rawValue, range: range)
    }
    
    /// strokeColor
    public func gl_add(strokeColor: UIColor?, range: NSRange? = nil) {
        gl_addAttribute(key: kCTStrokeColorAttributeName as NSAttributedString.Key, value: strokeColor?.cgColor, range: range)
        gl_addAttribute(key: .strokeColor, value: strokeColor, range: range)
    }
    
    /// strokeWidth
    public func gl_add(strokeWidth: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .strokeWidth, value: strokeWidth, range: range)
    }
    
    /// shadow
    public func gl_add(shadow: NSShadow?, range: NSRange? = nil) {
        gl_addAttribute(key: .shadow, value: shadow, range: range)
    }
    
    /// textEffect
    public func gl_add(textEffect: String?, range: NSRange? = nil) {
        gl_addAttribute(key: .textEffect, value: textEffect, range: range)
    }
    
    /// baselineOffset
    public func gl_add(baselineOffset: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .baselineOffset, value: baselineOffset, range: range)
    }
    
    /// obliqueness
    public func gl_add(obliqueness: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .obliqueness, value: obliqueness, range: range)
    }
    
    /// expansion
    public func gl_add(expansion: NSNumber?, range: NSRange? = nil) {
        gl_addAttribute(key: .expansion, value: expansion, range: range)
    }
}

/// MARK: - ParagraphStyle
extension NSMutableAttributedString {
    /// paragraphStyle
    public func gl_add(paragraphStyle: NSParagraphStyle, range: NSRange? = nil) {
        gl_addAttribute(key: .paragraphStyle, value: paragraphStyle, range: range)
    }
    
    /// alignment
    public func gl_add(alignment: NSTextAlignment, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.alignment = alignment
        }
    }
    
    /// lineSpacing
    public func gl_add(lineSpacing: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.lineSpacing = lineSpacing
        }
    }
    
    /// lineBreakMode（此方法慎用）
    /// 如果忽略`SwiftyLabel`中的`lineBreakMode`属性，而直接通过该方法设置富文本的`lineBreakMode`，最后只会显示一行
    /// 原因是`lineBreakMode`最后是设置到富文本的`NSParagraphStyle`段落样式的属性中。
    /// 当富文本中的`NSParagraphStyle`属性中的`lineBreakMode`值有意义，那么用`CTFramesetter`创建的`CTLine`就只会有一行
    public func gl_add(lineBreakMode: NSLineBreakMode, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.lineBreakMode = lineBreakMode
        }
    }
    
    /// paragraphSpacingBefore
    public func gl_add(paragraphSpacingBefore: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
    }
    
    /// paragraphSpacing
    public func gl_add(paragraphSpacing: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacing = paragraphSpacing
        }
    }
    
    /// firstLineHeadIndent
    public func gl_add(firstLineHeadIndent: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.firstLineHeadIndent = firstLineHeadIndent
        }
    }
    
    /// headIndent
    public func gl_add(headIndent: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.headIndent = headIndent
        }
    }
    
    /// tailIndent
    public func gl_add(tailIndent: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.tailIndent = tailIndent
        }
    }
    
    /// minimumLineHeight
    public func gl_add(minimumLineHeight: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.minimumLineHeight = minimumLineHeight
        }
    }
    
    /// maximumLineHeight
    public func gl_add(maximumLineHeight: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.maximumLineHeight = maximumLineHeight
        }
    }
    
    /// lineHeightMultiple
    public func gl_add(lineHeightMultiple: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.lineHeightMultiple = lineHeightMultiple
        }
    }
    
    /// hyphenationFactor
    public func gl_add(hyphenationFactor: Float, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.hyphenationFactor = hyphenationFactor
        }
    }
    
    /// defaultTabInterval
    public func gl_add(defaultTabInterval: CGFloat, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.defaultTabInterval = defaultTabInterval
        }
    }
    
    /// tabStops
    public func gl_add(tabStops: [NSTextTab]?, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.tabStops = tabStops
        }
    }
    
    /// baseWritingDirection
    public func gl_add(baseWritingDirection: NSWritingDirection, range: NSRange? = nil) {
        gl_paragraphStyleSet(range: range) { (style) in
            style.baseWritingDirection = baseWritingDirection
        }
    }
    
    /// set paragraph style
    private func gl_paragraphStyleSet(range: NSRange? ,closure: (NSMutableParagraphStyle)->()) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.enumerateAttribute(.paragraphStyle, in: _range, options: .longestEffectiveRangeNotRequired) { (value, subRange, _) in
            var _style: NSMutableParagraphStyle?
            if var value = value as? NSParagraphStyle {
                if CFGetTypeID(value) == CTParagraphStyleGetTypeID() {
                    value = NSParagraphStyle.gl_convert(ctStyle: value as! CTParagraphStyle)
                }
                _style = value.mutableCopy() as? NSMutableParagraphStyle
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

// MARK: - Base
extension NSMutableAttributedString {
    /// set attribute
    public func gl_addAttribute(key: NSAttributedString.Key, value: Any?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        removeAttribute(key, range: _range)
        if let value = value {
            addAttribute(key, value: value, range: _range)
        }
    }
    
    /// set attributes
    public func gl_addAttributes(attributes: [NSAttributedString.Key: Any]?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        guard let attributes = attributes else { return }
        self.setAttributes([:], range: _range)
        for atr in attributes {
            self.gl_addAttribute(key: atr.key, value: atr.value, range: _range)
        }
    }
}
