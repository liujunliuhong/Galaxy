//
//  SwiftyFlowItemsAutoMarginTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SnapKit

public class SwiftyFlowItemsAutoMarginTestViewController: UIViewController {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var scrollNode: SwiftyFlowItemsAutoMarginScrollNode = {
        let scrollNode = SwiftyFlowItemsAutoMarginScrollNode()
        scrollNode.backgroundColor = .orange
        return scrollNode
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubnode(self.scrollNode)
        self.scrollNode.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + 44.0)
        }
        self.scrollNode.reload()
    }
}
// MARK: - Auto Margin
fileprivate class SwiftyFlowItemsAutoMarginScrollNode: ASScrollNode {
    lazy var contentNode: SwiftyFlowItemsAutoMarginDisplayNode = {
        let contentNode = SwiftyFlowItemsAutoMarginDisplayNode()
        return contentNode
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
    }
    
    override func didLoad() {
        super.didLoad()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spec1 = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [self.contentNode])
        return spec1
    }
    
    func reload() {
        var nodes: [ASDisplayNode] = []
        for _ in 0..<50 {
            let node = ASDisplayNode()
            node.backgroundColor = .red
            nodes.append(node)
        }
        self.contentNode.setupAutoMargin(nodes: nodes, nodeWidth: 70.0, nodeHeight: 35.0, perRowCount: 3, verticalSpacing: 15, verticalEdgeInset: 10, horizontalEdgeInset: 10)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
