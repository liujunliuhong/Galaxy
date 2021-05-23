//
//  CTParagraphStyle+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/23.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreText
import UIKit

extension GL where Base == CTParagraphStyle {
    public var nsStyle: NSParagraphStyle {
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        // alignment
        var alignment: NSTextAlignment = .left
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .alignment,
                                                MemoryLayout<NSTextAlignment>.size,
                                                &alignment) {
            style.alignment = alignment
        }
        
        // firstLineHeadIndent
        var firstLineHeadIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .firstLineHeadIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &firstLineHeadIndent) {
            style.firstLineHeadIndent = firstLineHeadIndent
        }
        
        // headIndent
        var headIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .headIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &headIndent) {
            style.headIndent = headIndent
        }
        
        // tailIndent
        var tailIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .tailIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &tailIndent) {
            style.tailIndent = tailIndent
        }
        
        // tabStops
        var tabStops: CFArray = [] as CFArray
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .tabStops,
                                                MemoryLayout<CFArray>.size,
                                                &tabStops) {
            var tabs: [NSTextTab] = []
            for (_, obj) in (tabStops as NSArray).enumerated() {
                let ctTab: CTTextTab = obj as! CTTextTab
                let tab = NSTextTab(textAlignment: NSTextAlignment(CTTextTabGetAlignment(ctTab)), location: CGFloat(CTTextTabGetLocation(ctTab)), options: CTTextTabGetOptions(ctTab) as! [NSTextTab.OptionKey : Any])
                tabs.append(tab)
            }
            if tabs.count > 0 {
                style.tabStops = tabs
            }
        }
        
        // defaultTabInterval
        var defaultTabInterval:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .defaultTabInterval,
                                                MemoryLayout<CGFloat>.size,
                                                &defaultTabInterval) {
            style.defaultTabInterval = defaultTabInterval
        }
        
        // lineBreakMode
        var lineBreakMode:CTLineBreakMode = .byTruncatingTail
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .lineBreakMode,
                                                MemoryLayout<CTLineBreakMode>.size,
                                                &lineBreakMode) {
            var _lineBreakMode: NSLineBreakMode = .byTruncatingTail
            switch lineBreakMode {
                case .byCharWrapping:
                    _lineBreakMode = .byCharWrapping
                case .byClipping:
                    _lineBreakMode = .byClipping
                case .byTruncatingHead:
                    _lineBreakMode = .byTruncatingHead
                case .byTruncatingMiddle:
                    _lineBreakMode = .byTruncatingMiddle
                case .byTruncatingTail:
                    _lineBreakMode = .byTruncatingTail
                case .byWordWrapping:
                    _lineBreakMode = .byWordWrapping
                @unknown default:
                    _lineBreakMode = .byTruncatingTail
            }
            style.lineBreakMode = _lineBreakMode
        }
        
        
        // lineHeightMultiple
        var lineHeightMultiple:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .lineHeightMultiple,
                                                MemoryLayout<CGFloat>.size,
                                                &lineHeightMultiple) {
            style.lineHeightMultiple = lineHeightMultiple
        }
        
        // maximumLineHeight
        var maximumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .maximumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                &maximumLineHeight) {
            style.maximumLineHeight = maximumLineHeight
        }
        
        // minimumLineHeight
        var minimumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .minimumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                &minimumLineHeight) {
            style.minimumLineHeight = minimumLineHeight
        }
        
        
        // paragraphSpacing
        var paragraphSpacing:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .paragraphSpacing,
                                                MemoryLayout<CGFloat>.size,
                                                &paragraphSpacing) {
            style.paragraphSpacing = paragraphSpacing
        }
        
        // paragraphSpacingBefore
        var paragraphSpacingBefore:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .paragraphSpacingBefore,
                                                MemoryLayout<CGFloat>.size,
                                                &paragraphSpacingBefore) {
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
        
        // baseWritingDirection
        var baseWritingDirection:CTWritingDirection = .leftToRight
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .baseWritingDirection,
                                                MemoryLayout<CTWritingDirection>.size,
                                                &baseWritingDirection) {
            var _baseWritingDirection: NSWritingDirection = .leftToRight
            switch baseWritingDirection {
                case .leftToRight:
                    _baseWritingDirection = .leftToRight
                case .natural:
                    _baseWritingDirection = .natural
                case .rightToLeft:
                    _baseWritingDirection = .rightToLeft
                @unknown default:
                    _baseWritingDirection = .leftToRight
            }
            style.baseWritingDirection = _baseWritingDirection
        }
        
        
        var lineSpacing:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(base,
                                                .lineSpacingAdjustment,
                                                MemoryLayout<CGFloat>.size,
                                                &lineSpacing) {
            style.lineSpacing = lineSpacing
        }
        
        return style
    }
}
