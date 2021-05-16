//
//  NSParagraphStyle+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreText
import UIKit

extension NSParagraphStyle {
    
    public static func gl_nsStyle(with ctStyle: CTParagraphStyle) -> NSParagraphStyle {
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        // alignment
        var alignment: NSTextAlignment = .left
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .alignment,
                                                MemoryLayout<NSTextAlignment>.size,
                                                &alignment) {
            style.alignment = alignment
        }
        
        // firstLineHeadIndent
        var firstLineHeadIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .firstLineHeadIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &firstLineHeadIndent) {
            style.firstLineHeadIndent = firstLineHeadIndent
        }
        
        // headIndent
        var headIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .headIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &headIndent) {
            style.headIndent = headIndent
        }
        
        // tailIndent
        var tailIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .tailIndent,
                                                MemoryLayout<CGFloat>.size,
                                                &tailIndent) {
            style.tailIndent = tailIndent
        }
        
        // tabStops
        var tabStops: CFArray = [] as CFArray
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
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
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .defaultTabInterval,
                                                MemoryLayout<CGFloat>.size,
                                                &defaultTabInterval) {
            style.defaultTabInterval = defaultTabInterval
        }
        
        // lineBreakMode
        var lineBreakMode:CTLineBreakMode = .byTruncatingTail
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
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
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .lineHeightMultiple,
                                                MemoryLayout<CGFloat>.size,
                                                &lineHeightMultiple) {
            style.lineHeightMultiple = lineHeightMultiple
        }
        
        // maximumLineHeight
        var maximumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .maximumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                &maximumLineHeight) {
            style.maximumLineHeight = maximumLineHeight
        }
        
        // minimumLineHeight
        var minimumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .minimumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                &minimumLineHeight) {
            style.minimumLineHeight = minimumLineHeight
        }
        
        
        // paragraphSpacing
        var paragraphSpacing:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .paragraphSpacing,
                                                MemoryLayout<CGFloat>.size,
                                                &paragraphSpacing) {
            style.paragraphSpacing = paragraphSpacing
        }
        
        // paragraphSpacingBefore
        var paragraphSpacingBefore:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .paragraphSpacingBefore,
                                                MemoryLayout<CGFloat>.size,
                                                &paragraphSpacingBefore) {
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
        
        // baseWritingDirection
        var baseWritingDirection:CTWritingDirection = .leftToRight
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
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
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .lineSpacingAdjustment,
                                                MemoryLayout<CGFloat>.size,
                                                &lineSpacing) {
            style.lineSpacing = lineSpacing
        }
        
        return style
    }
    
    public func gl_CTStyle() -> CTParagraphStyle {
        var settings = [CTParagraphStyleSetting]()
        
        var lineSpacing: CGFloat = self.lineSpacing
        settings.append(withUnsafeMutableBytes(of: &lineSpacing, { CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paragraphSpacing: CGFloat = self.paragraphSpacing
        settings.append(withUnsafeMutableBytes(of: &paragraphSpacing, { CTParagraphStyleSetting(spec: .paragraphSpacing, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var alignment = CTTextAlignment(self.alignment)
        settings.append(withUnsafeMutableBytes(of: &alignment, { CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: $0.baseAddress!) }))
        
        var firstLineHeadIndent: CGFloat = self.firstLineHeadIndent
        settings.append(withUnsafeMutableBytes(of: &firstLineHeadIndent, { CTParagraphStyleSetting(spec: .firstLineHeadIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var headIndent: CGFloat = self.headIndent
        settings.append(withUnsafeMutableBytes(of: &headIndent, { CTParagraphStyleSetting(spec: .headIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var tailIndent: CGFloat = self.tailIndent
        settings.append(withUnsafeMutableBytes(of: &tailIndent, { CTParagraphStyleSetting(spec: .tailIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paraLineBreak = CTLineBreakMode(rawValue: UInt8(self.lineBreakMode.rawValue))
        settings.append(withUnsafeMutableBytes(of: &paraLineBreak, { CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: $0.baseAddress!) }))
        
        var minimumLineHeight: CGFloat = self.minimumLineHeight
        settings.append(withUnsafeMutableBytes(of: &minimumLineHeight, { CTParagraphStyleSetting(spec: .minimumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var maximumLineHeight: CGFloat = self.maximumLineHeight
        settings.append(withUnsafeMutableBytes(of: &maximumLineHeight, { CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paraWritingDirection = CTWritingDirection(rawValue: Int8(self.baseWritingDirection.rawValue))
        settings.append(withUnsafeMutableBytes(of: &paraWritingDirection, { CTParagraphStyleSetting(spec: .baseWritingDirection, valueSize: MemoryLayout<CTWritingDirection>.size, value: $0.baseAddress!) }))
        
        var lineHeightMultiple: CGFloat = self.lineHeightMultiple
        settings.append(withUnsafeMutableBytes(of: &lineHeightMultiple, { CTParagraphStyleSetting(spec: .lineHeightMultiple, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paragraphSpacingBefore: CGFloat = self.paragraphSpacingBefore
        settings.append(withUnsafeMutableBytes(of: &paragraphSpacingBefore, { CTParagraphStyleSetting(spec: .paragraphSpacingBefore, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        
        if self.responds(to: #selector(getter: self.tabStops)) {
            var tabs: [AnyHashable] = []
            let numTabs: Int = self.tabStops.count
            if numTabs != 0 {
                (self.tabStops as NSArray).enumerateObjects({ tab, idx, stop in
                    if let tab_: NSTextTab = tab as? NSTextTab {
                        let ctTab = CTTextTabCreate(CTTextAlignment.init(tab_.alignment), Double(tab_.location), tab_.options as CFDictionary)
                        tabs.append(ctTab)
                    }
                })
                var tabStops = tabs
                settings.append(withUnsafeMutableBytes(of: &tabStops, { CTParagraphStyleSetting(spec: .tabStops, valueSize: MemoryLayout<CFArray>.size, value: $0.baseAddress!) }))
            }
        }
        
        
        if self.responds(to: #selector(getter: self.defaultTabInterval)) {
            var defaultTabInterval: CGFloat = self.defaultTabInterval
            settings.append(withUnsafeMutableBytes(of: &defaultTabInterval, { CTParagraphStyleSetting(spec: .defaultTabInterval, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        }
        
        let style = CTParagraphStyleCreate(settings, settings.count)
        return style
    }
}

