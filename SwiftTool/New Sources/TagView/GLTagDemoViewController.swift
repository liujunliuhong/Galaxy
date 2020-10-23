//
//  GLTagDemoViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit


public class GLTagDemoViewController: UIViewController {

    
    private lazy var tagView: GLTagView = {
        let tagView = GLTagView()
        tagView.backgroundColor = .orange
        tagView.lineSpacing = 15.0
        tagView.interitemSpacing = 30.0
        tagView.preferdWidth = 250.0
        tagView.inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.verticalAlignment = .top
        return tagView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let topHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 80.0
        let left: CGFloat = 25.0
        
        self.view.addSubview(self.tagView)
        self.tagView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(left)
            make.top.equalToSuperview().offset(topHeight)
            make.right.equalToSuperview().offset(-20)
        }
        
        var items: [GLTagItem] = []
        
        let widths: [CGFloat] = [20, 30, 40, 50, 60, 70]
        let heights: [CGFloat] = [30, 40, 50, 60]
        
        for i in 0..<20 {
            let view = _View()
            if i == 5 {
                view.backgroundColor = .red
            } else {
                view.backgroundColor = .gray
            }
            view.button.setTitle("\(i)", for: .normal)
            let widthIndex = arc4random() % UInt32(widths.count)
            let heightIndex = arc4random() % UInt32(heights.count)
            let itemWidth = widths[Int(widthIndex)]
            let itemHeight = heights[Int(heightIndex)]
            let item = GLTagItem(view: view, width: itemWidth, height: itemHeight)
            items.append(item)
            
            view.tapClosure = {
                guard let v = item.view as? _View else { return }
                items.forEach { (item) in
                    if let vv = item.view as? _View {
                        vv.backgroundColor = .gray
                    }
                }
                v.backgroundColor = .red
            }
        }
        
        self.tagView.add(items: items)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // self.tagView.verticalAlignment = .bottom
            // self.tagView.removeItem(at: 10)
            // self.tagView.removeItems(at: [1, 3, 5, 7, 5])
            let view = _View()
            view.button.setTitle("Insert", for: .normal)
            view.backgroundColor = .green
            let item = GLTagItem(view: view, width: 100, height: 100)
            self.tagView.insert(item: item, at: 15)
        }
    }
}


fileprivate class _View: UIView {
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return button
    }()
    
    var tapClosure: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func tapAction(){
        self.tapClosure?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 20)
    }
}
