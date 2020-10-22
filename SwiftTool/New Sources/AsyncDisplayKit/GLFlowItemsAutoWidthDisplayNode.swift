//
//  GLFlowItemsAutoWidthDisplayNode.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AsyncDisplayKit


@objc public class GLFlowItemsAutoWidthDisplayNode: ASDisplayNode {
    private var perRowCount: Int = 0
    private var nodeHeightRatio: CGFloat = 1.0
    private var horizontalSpacing: CGFloat = 0.0
    private var verticalSpacing: CGFloat = 0.0
    private var verticalEdgeInset: CGFloat = 0.0
    private var horizontalEdgeInset: CGFloat = 0.0
    private var allNodes: [[ASDisplayNode]] = []
    
    override init() {
        super.init()
        backgroundColor = UIColor.gl_rgba(R: 0, G: 0, B: 0).withAlphaComponent(0)
    }
}

extension GLFlowItemsAutoWidthDisplayNode {
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.perRowCount <= 0 {
            return ASLayoutSpec()
        }
        let nodeWidth = (constrainedSize.max.width - self.horizontalEdgeInset * 2 - (self.horizontalSpacing * CGFloat(self.perRowCount - 1))) / CGFloat(self.perRowCount)
        if nodeWidth.isInfinite {
            return ASLayoutSpec()
        }
        if nodeWidth.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("⚠️ item width is less than or equal to 0, please check the parameter configuration")
            #endif
            return ASLayoutSpec()
        }
        if self.nodeHeightRatio.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            print("⚠️ nodeHeightRatio is less than or equal to 0, please check the parameter configuration")
            #endif
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

extension GLFlowItemsAutoWidthDisplayNode {
    /// 固定间距，动态宽度
    @objc public func setupAutoWidth(nodes: [ASDisplayNode],
                                     nodeHeightRatio: CGFloat,
                                     perRowCount: Int,
                                     verticalSpacing: CGFloat,
                                     horizontalSpacing: CGFloat,
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
        self.nodeHeightRatio = nodeHeightRatio
        self.horizontalSpacing = horizontalSpacing
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
