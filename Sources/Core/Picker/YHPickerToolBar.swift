//
//  YHPickerToolBar.swift
//  FNDating
//
//  Created by apple on 2019/9/11.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

// Can be inherited
open class YHPickerToolBar: UIView {
    
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    private let buttonWidth: CGFloat = 70.0
    
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
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.frame = CGRect(x: 0, y: 0, width: self.buttonWidth, height: self.frame.height)
        self.sureButton.frame = CGRect(x: self.frame.width - self.buttonWidth, y: 0, width: self.buttonWidth, height: self.frame.height)
        self.titleLabel.frame = CGRect(x: self.cancelButton.frame.maxX, y: 0, width: self.frame.width - self.cancelButton.frame.width - self.sureButton.frame.width, height: self.frame.height)
    }
}


extension YHPickerToolBar {
    private func makeUI() {
        addSubview(cancelButton)
        addSubview(sureButton)
        addSubview(titleLabel)
    }
}
