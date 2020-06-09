//
//  SwiftyCusNavigationBar.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/6/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

// dependency 'UIKit'
public class SwiftyCusNavigationBar: UIView {
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    public lazy var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .clear
        return barView
    }()
    
    public lazy var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
    public lazy var toolView: UIView = {
        let toolView = UIView()
        toolView.backgroundColor = .clear
        return toolView
    }()
    
    public var barHeight: CGFloat = 44.0
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCusNavigationBar {
    private func setup() {
        self.addSubview(self.barView)
        self.addSubview(self.lineView)
        self.addSubview(self.toolView)
    }
}


extension SwiftyCusNavigationBar {
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}




extension SwiftyCusNavigationBar {
    public func reload(origin: CGPoint, width: CGFloat) {
        
    }
}
