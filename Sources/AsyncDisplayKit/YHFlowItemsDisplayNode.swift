//
//  YHFlowItemsDisplayNode.swift
//  FNDating
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
#if canImport(AsyncDisplayKit)
import AsyncDisplayKit

@objc public class YHFlowItemsAutoWidthDisplayNode: ASDisplayNode {
    private var perRowCount: Int = 0
    private var nodeHeightRatio: CGFloat = 1.0
    private var horizontalSpacing: CGFloat = 0.0
    private var verticalSpacing: CGFloat = 0.0
    private var verticalEdgeInset: CGFloat = 0.0
    private var horizontalEdgeInset: CGFloat = 0.0
    private var allNodes: [[ASDisplayNode]] = []
    
    override init() {
        super.init()
        backgroundColor = .clear
    }
}

@objc public extension YHFlowItemsAutoWidthDisplayNode {
    @objc override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.perRowCount <= 0 {
            return ASLayoutSpec()
        }
        let nodeWidth = (constrainedSize.max.width - self.horizontalEdgeInset * 2 - (self.horizontalSpacing * CGFloat(self.perRowCount - 1))) / CGFloat(self.perRowCount)
        if nodeWidth.isInfinite {
            return ASLayoutSpec()
        }
        if nodeWidth.isLessThanOrEqualTo(.zero) {
            print("item宽度小于等于0，请检查参数配置")
            return ASLayoutSpec()
        }
        let nodeHeight = self.nodeHeightRatio * nodeWidth
        var specs: [ASLayoutElement] = []
        for (_, nodes) in self.allNodes.enumerated() {
            var subSpecs: [ASLayoutElement] = []
            for (_, node) in nodes.enumerated() {
                node.style.preferredSize = CGSize(width: nodeWidth, height: nodeHeight)
                subSpecs.append(node)
            }
            let spec2 = ASStackLayoutSpec(direction: .horizontal, spacing: self.horizontalSpacing, justifyContent: self.perRowCount == 1 ? .spaceAround : .spaceBetween, alignItems: .center, children: subSpecs)
            specs.append(spec2)
        }
        let spec3 = ASStackLayoutSpec(direction: .vertical, spacing: self.verticalSpacing, justifyContent: .start, alignItems: .stretch, children: specs)
        let spec4 = ASInsetLayoutSpec(insets: UIEdgeInsets(top: self.verticalEdgeInset, left: self.horizontalEdgeInset, bottom: self.verticalEdgeInset, right: self.horizontalEdgeInset), child: spec3)
        return spec4
    }
}

@objc public extension YHFlowItemsAutoWidthDisplayNode {
    
    /// 给定nodes集合，排列方式为固定间距，动态宽度。
    /// - Parameters:
    ///   - nodes: nodes集合
    ///   - nodeHeightRatio: 高宽比(用于确定高度)
    ///   - perRowCount: 每行多少个
    ///   - verticalSpacing: 行与行之间的间距
    ///   - horizontalSpacing: 水平方向上node之间的间距
    ///   - verticalEdgeInset: 垂直偏移量
    ///   - horizontalEdgeInset: 水平偏移量
    @objc func setupAutoWidth(nodes: [ASDisplayNode],
                               nodeHeightRatio: CGFloat,
                               perRowCount: Int,
                               verticalSpacing: CGFloat,
                               horizontalSpacing: CGFloat,
                               verticalEdgeInset: CGFloat,
                               horizontalEdgeInset: CGFloat) {
        //
        for (_, nodes) in self.allNodes.enumerated() {
            for (_, node) in nodes.enumerated() {
                node.removeFromSupernode()
            }
        }
        self.allNodes.removeAll()
        
        //
        self.perRowCount = perRowCount
        self.nodeHeightRatio = nodeHeightRatio
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.verticalEdgeInset = verticalEdgeInset
        self.horizontalEdgeInset = horizontalEdgeInset
        //
        self.allNodes = nodes.yh_group(perRowCount: perRowCount)
        for (_, nodes) in self.allNodes.enumerated() {
            for (_, node) in nodes.enumerated() {
                self.addSubnode(node)
            }
        }
        //
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}


@objc public class YHFlowItemsAutoMarginDisplayNode: ASDisplayNode {
    private var perRowCount: Int = 0
    private var nodeWidth: CGFloat = 0.0
    private var nodeHeight: CGFloat = 0.0
    private var verticalSpacing: CGFloat = 0.0
    private var verticalEdgeInset: CGFloat = 0.0
    private var horizontalEdgeInset: CGFloat = 0.0
    private var allNodes: [[ASDisplayNode]] = []
    override init() {
        super.init()
        backgroundColor = .clear
    }
}

@objc public extension YHFlowItemsAutoMarginDisplayNode {
    @objc override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.perRowCount <= 0 {
            return ASLayoutSpec()
        }
        if self.nodeWidth.isLessThanOrEqualTo(.zero) {
            print("item宽度小于等于0，请检查参数配置")
            return ASLayoutSpec()
        }
        if self.nodeHeight.isLessThanOrEqualTo(.zero) {
            print("item高度小于等于0，请检查参数配置")
            return ASLayoutSpec()
        }
        if constrainedSize.max.width.isInfinite {
            return ASLayoutSpec()
        }
        if self.nodeWidth > constrainedSize.max.width {
            print("item宽度大于容器宽度，请检查参数配置")
            return ASLayoutSpec()
        }
        
        var specs: [ASLayoutElement] = []
        for (_, nodes) in self.allNodes.enumerated() {
            var subSpecs: [ASLayoutElement] = []
            for (_, node) in nodes.enumerated() {
                node.style.preferredSize = CGSize(width: self.nodeWidth, height: self.nodeHeight)
                subSpecs.append(node)
            }
            let spec2 = ASStackLayoutSpec(direction: .horizontal, spacing: 0.0, justifyContent: self.perRowCount == 1 ? .spaceAround : .spaceBetween, alignItems: .center, children: subSpecs)
            specs.append(spec2)
        }
        let spec3 = ASStackLayoutSpec(direction: .vertical, spacing: self.verticalSpacing, justifyContent: .start, alignItems: .stretch, children: specs)
        let spec4 = ASInsetLayoutSpec(insets: UIEdgeInsets(top: self.verticalEdgeInset, left: self.horizontalEdgeInset, bottom: self.verticalEdgeInset, right: self.horizontalEdgeInset), child: spec3)
        return spec4
    }
}

@objc public extension YHFlowItemsAutoMarginDisplayNode {
    
    /// 给定nodes集合，排列方式为固定宽度，动态间距。
    /// 当最后一行不足`perRowCount`，则会以一个透明的`ASDisplayNode`代替
    /// - Parameters:
    ///   - nodes: nodes集合
    ///   - nodeWidth: 宽
    ///   - nodeHeightRatio: 高宽比
    ///   - perRowCount: 每行多少个
    ///   - verticalSpacing: 行与行之间的间隙
    ///   - verticalEdgeInset: 垂直偏移量
    ///   - horizontalEdgeInset: 水平偏移量
    @objc func setupAutoMargin(nodes: [ASDisplayNode],
                                nodeWidth: CGFloat,
                                nodeHeightRatio: CGFloat,
                                perRowCount: Int,
                                verticalSpacing: CGFloat,
                                verticalEdgeInset: CGFloat,
                                horizontalEdgeInset: CGFloat) {
        
        
        let nodeHeight = nodeWidth * nodeHeightRatio
        self.setupAutoMargin(nodes: nodes,
                             nodeWidth: nodeWidth,
                             nodeHeight: nodeHeight,
                             perRowCount: perRowCount,
                             verticalSpacing: verticalSpacing,
                             verticalEdgeInset: verticalEdgeInset,
                             horizontalEdgeInset: horizontalEdgeInset)
    }
    
    /// 给定nodes集合，排列方式为固定宽度，动态间距。
    /// 当最后一行不足`perRowCount`，则会以一个透明的`ASDisplayNode`代替
    /// - Parameters:
    ///   - nodes: nodes集合
    ///   - nodeWidth: 宽
    ///   - nodeHeight: 高
    ///   - perRowCount: 每行多少个
    ///   - verticalSpacing: 行与行之间的间隙
    ///   - verticalEdgeInset: 垂直偏移量
    ///   - horizontalEdgeInset: 水平偏移量
    @objc func setupAutoMargin(nodes: [ASDisplayNode],
                                nodeWidth: CGFloat,
                                nodeHeight: CGFloat,
                                perRowCount: Int,
                                verticalSpacing: CGFloat,
                                verticalEdgeInset: CGFloat,
                                horizontalEdgeInset: CGFloat) {
        //
        for (_, nodes) in self.allNodes.enumerated() {
            for (_, node) in nodes.enumerated() {
                node.removeFromSupernode()
            }
        }
        self.allNodes.removeAll()
        //
        self.perRowCount = perRowCount
        self.nodeHeight = nodeHeight
        self.nodeWidth = nodeWidth
        self.verticalSpacing = verticalSpacing
        self.verticalEdgeInset = verticalEdgeInset
        self.horizontalEdgeInset = horizontalEdgeInset
        //
        self.allNodes = nodes.yh_group(perRowCount: perRowCount)
        for (_, nodes) in self.allNodes.enumerated() {
            for (_, node) in nodes.enumerated() {
                self.addSubnode(node)
            }
        }
        //
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}


#endif
