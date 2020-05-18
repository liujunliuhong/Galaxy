//
//  SwiftyTagContainerView.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public protocol SwiftyTagContainerProtocol {
    func tagView() -> UIView
    func tagWidth() -> CGFloat
}


public class SwiftyTagContainerView: UIView {
    deinit {
        #if DEBUG
        print("\(self.classForCoder) deinit")
        #endif
    }
    
    private let containerWidth: CGFloat
    private let tagHeight: CGFloat
    private let lineSpace: CGFloat
    private let columnSpace: CGFloat
    private var lastTags: [UIView] = []
    
    
    /// init
    /// - Parameters:
    ///   - containerWidth: container width
    ///   - tagHeight: tag height
    ///   - lineSpace: line space
    ///   - columnSpace: column space
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


public extension SwiftyTagContainerView {
    
    /// reload
    /// - Parameter tags: tags
    /// - Returns: container height
    @discardableResult func reload(with tags: [SwiftyTagContainerProtocol]) -> CGFloat {
        self.lastTags.forEach { (tagView) in
            tagView.removeFromSuperview()
        }
        self.lastTags.removeAll()
        
        var lastTagView: UIView?
        
        for (_, tag) in tags.enumerated() {
            let tagView = tag.tagView()
            let tagWidth = tag.tagWidth() > self.containerWidth ? self.containerWidth : tag.tagWidth() // limit width
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
