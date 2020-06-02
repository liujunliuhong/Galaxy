//
//  SwiftyFlowItemsDisplayNode.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AsyncDisplayKit

fileprivate extension Array where Element: ASDisplayNode {
    /// A certain number of collections are grouped. The elements in the collection must inherit from `ASDisplayNode`. If the last line is less than `perRowCount`, use the default initialization
    /// - Parameter perRowCount: perRowCount
    /// - Returns: grouped
    func group(perRowCount: Int) -> [[Element]] {
        var allValues: [Element] = []
        //
        let remainCount = self.count % perRowCount // The remaining amount is not full
        for (_, value) in self.enumerated() {
            allValues.append(value)
        }
        // Remaining fill
        if remainCount > 0 {
            for _ in 0..<(perRowCount - remainCount) {
                allValues.append(Element.init())
            }
        }
        //
        var finalAllValues: [[Element]] = []
        // Now the number of `allValues` must be an integer multiple of `perRowCount`
        let rowCount = allValues.count / perRowCount // Rows full
        for i in 0..<rowCount {
            var subValues: [Element] = []
            for j in 0..<perRowCount {
                let index = i * perRowCount + j
                subValues.append(allValues[index])
            }
            finalAllValues.append(subValues)
        }
        return finalAllValues
    }
}





// MARK: - AutoWidth
@objc public class SwiftyFlowItemsAutoWidthDisplayNode: ASDisplayNode {
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

@objc public extension SwiftyFlowItemsAutoWidthDisplayNode {
    @objc override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
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

@objc public extension SwiftyFlowItemsAutoWidthDisplayNode {
    /// Given a set of nodes, the arrangement is fixed pitch, dynamic width.
    /// - Parameters:
    ///   - nodes: nodes
    ///   - nodeHeightRatio: Aspect ratio (used to determine height)
    ///   - perRowCount: How many per line
    ///   - verticalSpacing: Line-to-line spacing
    ///   - horizontalSpacing: The spacing between nodes in the horizontal direction
    ///   - verticalEdgeInset: Vertical offset
    ///   - horizontalEdgeInset: Horizontal offset
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
        self.allNodes = nodes.group(perRowCount: perRowCount)
        for (_, node) in (self.allNodes.flatMap{ $0 }).enumerated() {
            self.addSubnode(node)
        }
        //
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}








// MARK: - AutoMargin
@objc public class SwiftyFlowItemsAutoMarginDisplayNode: ASDisplayNode {
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

@objc public extension SwiftyFlowItemsAutoMarginDisplayNode {
    @objc override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
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

@objc public extension SwiftyFlowItemsAutoMarginDisplayNode {
    /// Given a set of nodes, the arrangement is fixed width and dynamic spacing. When the last line is less than `perRowCount`, it will be replaced by a transparent `ASDisplayNode`
    /// - Parameters:
    ///   - nodes: Nodes
    ///   - nodeWidth: Node width
    ///   - nodeHeightRatio: Aspect Ratio
    ///   - perRowCount: How many per line
    ///   - verticalSpacing: Line-to-line gap
    ///   - verticalEdgeInset: Vertical offset
    ///   - horizontalEdgeInset: Horizontal offset
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
    
    /// Given a set of nodes, the arrangement is fixed width and dynamic spacing. When the last line is less than `perRowCount`, it will be replaced by a transparent `ASDisplayNode`
    /// - Parameters:
    ///   - nodes: Nodes
    ///   - nodeWidth: Node width
    ///   - nodeHeight: Node height
    ///   - perRowCount: How many per line
    ///   - verticalSpacing: Line-to-line gap
    ///   - verticalEdgeInset: Vertical offset
    ///   - horizontalEdgeInset: Horizontal offset
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
        self.allNodes = nodes.group(perRowCount: perRowCount)
        for (_, node) in (self.allNodes.flatMap{ $0 }).enumerated() {
            self.addSubnode(node)
        }
        //
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

