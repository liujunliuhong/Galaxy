//
//  YHPickerToolBar.swift
//  FNDating
//
//  Created by apple on 2019/9/11.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHPickerToolBar: UIView {
    
    private let buttonWidth: CGFloat = 70.0
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.setTitle("Cancel", for: .normal)
        return cancelButton
    }()
    
    lazy var sureButton: UIButton = {
        let sureButton = UIButton(type: .system)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sureButton.setTitle("Done", for: .normal)
        return sureButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    init() {
        super.init(frame: .zero)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: self.YH_Height)
        self.sureButton.frame = CGRect(x: self.YH_Width - buttonWidth, y: 0, width: buttonWidth, height: self.YH_Height)
        self.titleLabel.frame = CGRect(x: self.cancelButton.YH_Right, y: 0, width: self.YH_Width - self.cancelButton.YH_Width - self.sureButton.YH_Width, height: self.YH_Height)
    }
}


extension YHPickerToolBar {
    func makeUI() {
        addSubview(cancelButton)
        addSubview(sureButton)
        addSubview(titleLabel)
    }
}
