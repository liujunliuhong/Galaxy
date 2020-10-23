//
//  GLTagView.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

/// 垂直对其方式。当每个`item`的高度不一样时，能看到明显的效果
public enum GLTagVerticalAlignment {
    case center   // 居中
    case top      // 置顶
    case bottom   // 置底
}

public class GLTagView: UIView {
    deinit {
        self.removeNotification()
    }
    /// 容器偏移量
    public var inset: UIEdgeInsets = .zero
    /// 行间距
    public var lineSpacing: CGFloat = .zero
    /// 列间距
    public var interitemSpacing: CGFloat = .zero
    /// 总共有几行
    public private(set) var rowCount: Int = 0
    /// 容器宽度。优先使用容器本身的宽度(self.frame.width)，如果容器本身宽度小于`0`，那么容器宽度就是`preferdWidth`
    public var preferdWidth: CGFloat = .zero {
        didSet {
            self.shouldLayout = true
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    /// 垂直对其方式。默认置顶
    public var verticalAlignment: GLTagVerticalAlignment = .top {
        didSet {
            self.shouldLayout = true
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    /// `item`集合
    private var items: [GLTagItem] = []
    /// 是否可以布局。防止多次调用
    private var shouldLayout: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addNotification()
    }
    
    public init() {
        super.init(frame: .zero)
        self.addNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GLTagView {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func orientationDidChange() {
        self.shouldLayout = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
}

extension GLTagView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.shouldLayout {
            return
        }
        self.reloadUI(isLayoutItem: true)
        self.shouldLayout = false
    }
}

extension GLTagView {
    public override var intrinsicContentSize: CGSize {
        return self.reloadUI(isLayoutItem: false)
    }
}

extension GLTagView {
    @discardableResult
    private func reloadUI(isLayoutItem: Bool) -> CGSize {
        //
        let containerWidth: CGFloat = self.bounds.width.isLessThanOrEqualTo(.zero) ? self.preferdWidth : self.bounds.width
        if containerWidth.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("The content width is less than 0")
            #endif
            return .zero
        }
        if (containerWidth - self.inset.left - self.inset.right).isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("The actual content width is less than 0")
            #endif
            return .zero
        }
        if self.items.count <= 0 {
            #if DEBUG
            print("The number of items is 0")
            #endif
            return .zero
        }
        
        
        let topPadding: CGFloat = self.inset.top
        let leftPadding: CGFloat = self.inset.left
        let rightPadding: CGFloat = self.inset.right
        let bottomPadding: CGFloat = self.inset.bottom
        
        var preItem: GLTagItem? = nil
        
        var X: CGFloat = leftPadding
        
        var rowCount: Int = 0
        var maxUpLineHeight: CGFloat = 0
        
        let intrinsicWidth: CGFloat = containerWidth
        var intrinsicHeight: CGFloat = .zero
        
        var alignmentItems: [GLTagItem] = []
        
        for (_, item) in self.items.enumerated() {
            //
            let itemIntrinsicContentSize: CGSize = item.view.intrinsicContentSize
            //
            var width: CGFloat = item.width.isLessThanOrEqualTo(.zero) ? itemIntrinsicContentSize.width : item.width
            width = width.isLessThanOrEqualTo(.zero) ? .zero : width
            width = min(width, containerWidth - leftPadding - rightPadding)
            width = width.isLessThanOrEqualTo(.zero) ? .zero : width
            //
            var height: CGFloat = item.height.isLessThanOrEqualTo(.zero) ? itemIntrinsicContentSize.height : item.height
            height = height.isLessThanOrEqualTo(.zero) ? .zero : height
            //
            if preItem != nil {
                if (X + width + rightPadding).isLessThanOrEqualTo(containerWidth) { /* 不需要换行 */
                    if isLayoutItem {
                        item.view.frame = CGRect(x: X, y: preItem!.view.frame.minY, width: width, height: height)
                    }
                    if maxUpLineHeight.isLess(than: preItem!.view.frame.minY + height) {
                        maxUpLineHeight = preItem!.view.frame.minY + height
                    }
                    X += (width + self.interitemSpacing)
                    //
                    alignmentItems.append(item)
                } else {  /* 需要换行 */
                    //
                    self.layoutAlignment(items: alignmentItems)
                    alignmentItems.removeAll()
                    //
                    rowCount += 1
                    maxUpLineHeight += self.lineSpacing
                    X = leftPadding
                    if isLayoutItem {
                        item.view.frame = CGRect(x: X, y: maxUpLineHeight, width: width, height: height)
                    }
                    X += (width + self.interitemSpacing)
                    maxUpLineHeight += height
                    //
                    alignmentItems.append(item)
                }
            } else {
                // 没有上一个item，也就是第一个item
                rowCount += 1
                maxUpLineHeight = topPadding
                if isLayoutItem {
                    item.view.frame = CGRect(x: X, y: maxUpLineHeight, width: width, height: height)
                }
                X += (width + self.interitemSpacing)
                maxUpLineHeight += height
                //
                alignmentItems.append(item)
            }
            preItem = item
        }
        //
        self.layoutAlignment(items: alignmentItems)
        alignmentItems.removeAll()
        //
        intrinsicHeight = maxUpLineHeight + bottomPadding
        //
        self.rowCount = rowCount
        //
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    private func layoutAlignment(items: [GLTagItem]) {
        if items.count <= 0 {
            return
        }
        //
        if self.verticalAlignment == .top { /* top */
            var top: CGFloat = items.first!.view.frame.minY
            let tops = items.map{ $0.view.frame.minY }
            tops.forEach { (_top) in
                top = min(top, _top)
            }
            for (_, item) in items.enumerated() {
                item.view.frame.origin = CGPoint(x: item.view.frame.origin.x, y: top)
            }
        } else if self.verticalAlignment == .center { /* centerY */
            var centerY: CGFloat = items.first!.view.center.y
            let centerYs = items.map{ $0.view.center.y }
            centerYs.forEach { (_centerY) in
                centerY = max(centerY, _centerY)
            }
            for (_, item) in items.enumerated() {
                item.view.center = CGPoint(x: item.view.center.x, y: centerY)
            }
        } else { /* bottom */
            var bottom: CGFloat = items.first!.view.frame.maxY
            let bottoms = items.map{ $0.view.frame.maxY }
            bottoms.forEach { (_bottom) in
                bottom = max(bottom, _bottom)
            }
            for (_, item) in items.enumerated() {
                var frame = item.view.frame
                frame.origin.y = bottom - item.view.frame.height
                item.view.frame = frame
            }
        }
    }
}

extension GLTagView {
    public func add(items: [GLTagItem]) {
        for (_, item) in items.enumerated() {
            self.addSubview(item.view)
            self.items.append(item)
        }
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func add(item: GLTagItem) {
        self.addSubview(item.view)
        self.items.append(item)
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func insert(item: GLTagItem, at index: Int) {
        if index > self.items.count - 1 {
            self.add(item: item)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        self.insertSubview(item.view, at: index)
        self.items.insert(item, at: index)
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func insert(items: [GLTagItem], at index: Int) {
        if index > self.items.count - 1 {
            self.add(items: items)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        for (_index, item) in items.enumerated() {
            let i = _index + index
            self.insertSubview(item.view, at: i)
            self.items.insert(item, at: i)
        }
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    
    public func remove(item: GLTagItem) {
        for (index, _item) in self.items.enumerated() {
            if item.identifier == _item.identifier {
                self.items.remove(at: index)
                _item.view.removeFromSuperview()
                self.shouldLayout = true
                self.layoutIfNeeded()
                self.invalidateIntrinsicContentSize()
                break
            }
        }
    }
    
    public func remove(items: [GLTagItem]) {
        for (_, i_item) in items.enumerated() {
            for (j, j_item) in self.items.enumerated() {
                if j_item.identifier == i_item.identifier {
                    self.items.remove(at: j)
                    j_item.view.removeFromSuperview()
                    break
                }
            }
        }
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func removeItem(at index: Int) {
        if index < 0 {
            return
        }
        if index >= self.items.count {
            return
        }
        let item = self.items.remove(at: index)
        item.view.removeFromSuperview()
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
    
    public func removeItems(at indexs: [Int]) {
        var hasIndexs: [Int] = []
        for (_, index) in indexs.enumerated() {
            if index < 0 {
                continue
            }
            if index >= self.items.count {
                continue
            }
            if hasIndexs.contains(index) {
                continue
            }
            let item = self.items.remove(at: index)
            item.view.removeFromSuperview()
            hasIndexs.append(index)
        }
        self.shouldLayout = true
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
}
