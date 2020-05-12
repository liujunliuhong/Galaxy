//
//  YHTagContainerView.swift
//  TMM
//
//  Created by apple on 2019/11/28.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit


public protocol YHTagContainerProtocol {
    func tagView() -> UIView
    func tagWidth() -> CGFloat
}


public class YHTagContainerView: UIView {
    
    private let containerWidth: CGFloat
    private let tagHeight: CGFloat
    private let lineSpace: CGFloat
    private let columnSpace: CGFloat
    private var lastTags: [UIView] = []
    
    
    /// init
    /// - Parameter containerWidth: container width
    /// - Parameter tagHeight: tag height
    /// - Parameter lineSpace: line space
    /// - Parameter columnSpace: column space
    public required init(with containerWidth: CGFloat, tagHeight: CGFloat, lineSpace: CGFloat, columnSpace: CGFloat) {
        self.containerWidth = containerWidth
        self.tagHeight = tagHeight
        self.lineSpace = lineSpace
        self.columnSpace = columnSpace
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension YHTagContainerView {
    
    /// reload
    /// - Parameter tags: tags
    @discardableResult func reload(with tags: [YHTagContainerProtocol]) -> CGFloat {
        self.lastTags.forEach { (tagView) in
            tagView.removeFromSuperview()
        }
        self.lastTags.removeAll()

        var lastTagView: UIView?
        
        for (_, tag) in tags.enumerated() {
            let tagView = tag.tagView()
            let tagWidth = tag.tagWidth() > self.containerWidth ? self.containerWidth : tag.tagWidth() // 宽度限制
            self.addSubview(tagView)
            self.lastTags.append(tagView)
            
            if lastTagView == nil {
                // first
                tagView.frame = CGRect(x: 0, y: 0, width: tagWidth, height: self.tagHeight)
            } else {
                // judge if need new line
                if lastTagView!.frame.origin.x + lastTagView!.frame.size.width + self.columnSpace + tagWidth > self.containerWidth {
                    // need new line
                    tagView.frame = CGRect(x: 0, y: lastTagView!.frame.origin.y + lastTagView!.frame.size.height + self.lineSpace, width: tagWidth, height: self.tagHeight)
                } else {
                    // not need new line
                    tagView.frame = CGRect(x: lastTagView!.frame.origin.x + lastTagView!.frame.size.width + self.columnSpace, y: lastTagView!.frame.origin.y, width: tagWidth, height: self.tagHeight)
                }
            }
            lastTagView = tagView
        }
        
        if let _lastTagView = lastTagView {
            return _lastTagView.frame.origin.y + _lastTagView.frame.size.height
        } else {
            return 0.0
        }
    }
}
