//
//  SwiftyPickerToolBar.swift
//  SwiftTool
//
//  Created by liujun on 2020/5/13.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

// Can be inherited
open class SwiftyPickerToolBar: UIView {
    
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    //private let buttonWidth: CGFloat = 70.0
    
    open lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.setTitle("Cancel", for: .normal)
        return cancelButton
    }()
    
    open lazy var sureButton: UIButton = {
        let sureButton = UIButton(type: .system)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sureButton.setTitle("Done", for: .normal)
        return sureButton
    }()
    
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    public init() {
        super.init(frame: .zero)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // You can override this method to change the layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.sizeToFit()
        self.sureButton.sizeToFit()
        
        let cancelButtonWidth = self.cancelButton.frame.width
        let sureButtonWidth = self.sureButton.frame.width
        
        self.cancelButton.frame = CGRect(x: 5, y: 0, width: cancelButtonWidth, height: self.frame.height)
        self.sureButton.frame = CGRect(x: self.frame.width - sureButtonWidth - 5, y: 0, width: sureButtonWidth, height: self.frame.height)
        
        let distance = max((self.frame.width - self.sureButton.frame.minX), self.cancelButton.frame.maxX)
        let titleWidth = self.frame.width - 2.0 * distance
        self.titleLabel.frame = CGRect(x: distance, y: 0, width: titleWidth, height: self.frame.height)
    }
}


extension SwiftyPickerToolBar {
    private func makeUI() {
        addSubview(cancelButton)
        addSubview(sureButton)
        addSubview(titleLabel)
    }
}
