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

extension GL where Base == NSParagraphStyle {
    
    public var stStyle: CTParagraphStyle {
        var settings = [CTParagraphStyleSetting]()
        
        var lineSpacing: CGFloat = base.lineSpacing
        settings.append(withUnsafeMutableBytes(of: &lineSpacing, { CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paragraphSpacing: CGFloat = base.paragraphSpacing
        settings.append(withUnsafeMutableBytes(of: &paragraphSpacing, { CTParagraphStyleSetting(spec: .paragraphSpacing, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var alignment = CTTextAlignment(base.alignment)
        settings.append(withUnsafeMutableBytes(of: &alignment, { CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: $0.baseAddress!) }))
        
        var firstLineHeadIndent: CGFloat = base.firstLineHeadIndent
        settings.append(withUnsafeMutableBytes(of: &firstLineHeadIndent, { CTParagraphStyleSetting(spec: .firstLineHeadIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var headIndent: CGFloat = base.headIndent
        settings.append(withUnsafeMutableBytes(of: &headIndent, { CTParagraphStyleSetting(spec: .headIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var tailIndent: CGFloat = base.tailIndent
        settings.append(withUnsafeMutableBytes(of: &tailIndent, { CTParagraphStyleSetting(spec: .tailIndent, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paraLineBreak = CTLineBreakMode(rawValue: UInt8(base.lineBreakMode.rawValue))
        settings.append(withUnsafeMutableBytes(of: &paraLineBreak, { CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: $0.baseAddress!) }))
        
        var minimumLineHeight: CGFloat = base.minimumLineHeight
        settings.append(withUnsafeMutableBytes(of: &minimumLineHeight, { CTParagraphStyleSetting(spec: .minimumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var maximumLineHeight: CGFloat = base.maximumLineHeight
        settings.append(withUnsafeMutableBytes(of: &maximumLineHeight, { CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paraWritingDirection = CTWritingDirection(rawValue: Int8(base.baseWritingDirection.rawValue))
        settings.append(withUnsafeMutableBytes(of: &paraWritingDirection, { CTParagraphStyleSetting(spec: .baseWritingDirection, valueSize: MemoryLayout<CTWritingDirection>.size, value: $0.baseAddress!) }))
        
        var lineHeightMultiple: CGFloat = base.lineHeightMultiple
        settings.append(withUnsafeMutableBytes(of: &lineHeightMultiple, { CTParagraphStyleSetting(spec: .lineHeightMultiple, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        var paragraphSpacingBefore: CGFloat = base.paragraphSpacingBefore
        settings.append(withUnsafeMutableBytes(of: &paragraphSpacingBefore, { CTParagraphStyleSetting(spec: .paragraphSpacingBefore, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        
        
        if base.responds(to: #selector(getter: base.tabStops)) {
            var tabs: [AnyHashable] = []
            let numTabs: Int = base.tabStops.count
            if numTabs != 0 {
                (base.tabStops as NSArray).enumerateObjects({ tab, idx, stop in
                    if let tab_: NSTextTab = tab as? NSTextTab {
                        let ctTab = CTTextTabCreate(CTTextAlignment.init(tab_.alignment), Double(tab_.location), tab_.options as CFDictionary)
                        tabs.append(ctTab)
                    }
                })
                var tabStops = tabs
                settings.append(withUnsafeMutableBytes(of: &tabStops, { CTParagraphStyleSetting(spec: .tabStops, valueSize: MemoryLayout<CFArray>.size, value: $0.baseAddress!) }))
            }
        }
        
        
        if base.responds(to: #selector(getter: base.defaultTabInterval)) {
            var defaultTabInterval: CGFloat = base.defaultTabInterval
            settings.append(withUnsafeMutableBytes(of: &defaultTabInterval, { CTParagraphStyleSetting(spec: .defaultTabInterval, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!) }))
        }
        
        let style = CTParagraphStyleCreate(settings, settings.count)
        return style
    }
}

