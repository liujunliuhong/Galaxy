//
//  GLFlowItemsDemoViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import AsyncDisplayKit

public enum GLFlowItemsType {
    case autoWidth
    case autoMargin
}

public class GLFlowItemsDemoViewController: UIViewController {
    
    private lazy var scrollNode: _ScrollNode = {
        let scrollNode = _ScrollNode(type: self.type)
        return scrollNode
    }()
    
    private let type: GLFlowItemsType
    public init(type: GLFlowItemsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubnode(self.scrollNode)
        let topHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44.0
        let bottomHeight: CGFloat = 50.0
        self.scrollNode.frame = CGRect(x: 0,
                                       y: topHeight,
                                       width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height - topHeight - bottomHeight)
        
        self.scrollNode.reloadData()
    }
}


fileprivate class _ScrollNode: ASScrollNode {
    
    private lazy var autoWidthContentNode: GLFlowItemsAutoWidthDisplayNode = {
        let autoWidthContentNode = GLFlowItemsAutoWidthDisplayNode()
        autoWidthContentNode.backgroundColor = .orange
        return autoWidthContentNode
    }()
    
    private lazy var autoMarginContentNode: GLFlowItemsAutoMarginDisplayNode = {
        let autoMarginContentNode = GLFlowItemsAutoMarginDisplayNode()
        autoMarginContentNode.backgroundColor = .orange
        return autoMarginContentNode
    }()
    
    let type: GLFlowItemsType
    init(type: GLFlowItemsType) {
        self.type = type
        super.init()
        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
    }
    
    override func didLoad() {
        super.didLoad()
        view.alwaysBounceVertical = true
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.type == .autoWidth {
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [self.autoWidthContentNode])
        } else {
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [self.autoMarginContentNode])
        }
    }
}


extension _ScrollNode {
    func reloadData() {
        var nodes: [ASDisplayNode] = []
        for i in 0..<53 {
            let node = _Cell()
            node.set(index: i)
            node.backgroundColor = UIColor.red
            nodes.append(node)
        }
        if self.type == .autoWidth {
            self.autoWidthContentNode.setupAutoWidth(nodes: nodes, nodeHeightRatio: 0.6, perRowCount: 4, verticalSpacing: 20, horizontalSpacing: 10, verticalEdgeInset: 10, horizontalEdgeInset: 10) { () -> (ASDisplayNode) in
                let defaultNode = ASDisplayNode()
                defaultNode.backgroundColor = UIColor.gl_rgba(R: 0, G: 0, B: 0).withAlphaComponent(0)
                return defaultNode
            }
        } else {
            self.autoMarginContentNode.setupAutoMargin(nodes: nodes, nodeWidth: 50, nodeHeightRatio: 2.0, perRowCount: 4, verticalSpacing: 20, verticalEdgeInset: 10, horizontalEdgeInset: 10) { () -> (ASDisplayNode) in
                let defaultNode = ASDisplayNode()
                defaultNode.backgroundColor = UIColor.gl_rgba(R: 0, G: 0, B: 0).withAlphaComponent(0)
                return defaultNode
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}


fileprivate class _Cell: ASDisplayNode {
    lazy var titleNode: ASTextNode = {
        let titleNode = ASTextNode()
        titleNode.maximumNumberOfLines = 0
        titleNode.style.flexShrink = 1
        return titleNode
    }()
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    func set(index: Int) {
        self.titleNode.attributedText = NSMutableAttributedString(string: "\(index)", attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                                                   .foregroundColor: UIColor.white])
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.titleNode.style.maxHeight = ASDimensionMake(constrainedSize.max.height)
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .stretch, children: [self.titleNode])
    }
}
