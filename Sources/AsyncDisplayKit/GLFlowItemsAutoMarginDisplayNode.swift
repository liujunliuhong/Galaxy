//
//  GLFlowItemsAutoMarginDisplayNode.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AsyncDisplayKit


@objc public class GLFlowItemsAutoMarginDisplayNode: ASDisplayNode {
    private var perRowCount: Int = 0
    private var nodeWidth: CGFloat = 0.0
    private var nodeHeight: CGFloat = 0.0
    private var verticalSpacing: CGFloat = 0.0
    private var verticalEdgeInset: CGFloat = 0.0
    private var horizontalEdgeInset: CGFloat = 0.0
    private var allNodes: [[ASDisplayNode]] = []
    override init() {
        super.init()
        
    }
}

extension GLFlowItemsAutoMarginDisplayNode {
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.perRowCount <= 0 {
            return ASLayoutSpec()
        }
        if self.nodeWidth.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("⚠️ item width is less than or equal to 0, please check the parameter configuration")
            #endif
            return ASLayoutSpec()
        }
        if self.nodeHeight.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("⚠️ item height is less than or equal to 0, please check the parameter configuration")
            #endif
            return ASLayoutSpec()
        }
        if constrainedSize.max.width.isInfinite {
            return ASLayoutSpec()
        }
        if self.nodeWidth > constrainedSize.max.width {
            #if DEBUG
            print("⚠️ item width is greater than container width, please check parameter configuration")
            #endif
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

extension GLFlowItemsAutoMarginDisplayNode {
    /// 固定宽度，自动间距
    @objc public func setupAutoMargin(nodes: [ASDisplayNode],
                                      nodeWidth: CGFloat,
                                      nodeHeightRatio: CGFloat,
                                      perRowCount: Int,
                                      verticalSpacing: CGFloat,
                                      verticalEdgeInset: CGFloat,
                                      horizontalEdgeInset: CGFloat,
                                      defaultValueClosure: (()->(ASDisplayNode))?) {
        let nodeHeight = nodeWidth * nodeHeightRatio
        self.setupAutoMargin(nodes: nodes,
                             nodeWidth: nodeWidth,
                             nodeHeight: nodeHeight,
                             perRowCount: perRowCount,
                             verticalSpacing: verticalSpacing,
                             verticalEdgeInset: verticalEdgeInset,
                             horizontalEdgeInset: horizontalEdgeInset,
                             defaultValueClosure: defaultValueClosure)
    }
    
    /// 固定宽度，自动间距
    @objc public func setupAutoMargin(nodes: [ASDisplayNode],
                                      nodeWidth: CGFloat,
                                      nodeHeight: CGFloat,
                                      perRowCount: Int,
                                      verticalSpacing: CGFloat,
                                      verticalEdgeInset: CGFloat,
                                      horizontalEdgeInset: CGFloat,
                                      defaultValueClosure: (()->(ASDisplayNode))?) {
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
        self.allNodes = nodes.gl_group(perRowCount: perRowCount, isMakeUp: true, defaultValueClosure: defaultValueClosure)
        for (_, node) in (self.allNodes.flatMap{ $0 }).enumerated() {
            self.addSubnode(node)
        }
        //
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

