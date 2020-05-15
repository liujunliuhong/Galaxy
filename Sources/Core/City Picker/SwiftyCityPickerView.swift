//
//  SwiftyCityPickerView.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class SwiftyCityPickerView: SwiftyPickerView {
    
    public lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftyCityPickerView {
    @discardableResult override func show(doneClosure: SwiftyPickerDoneClosure?) -> Bool {
        guard super.show(doneClosure: doneClosure) else { return false }
        
        self.pickerView.isHidden = true
        self.toolBar.isHidden = true
        
        self.addSubview(self.loadingView)
        self.loadingView.frame = self.bounds
        self.loadingView.startAnimating()
        
        return true
    }
    override func dismiss() {
        super.dismiss()
    }
}


extension SwiftyCityPickerView {
    
}
