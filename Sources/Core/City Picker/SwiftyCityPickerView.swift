//
//  SwiftyCityPickerView.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SwiftyJSON

public func SwiftyCityPickerLoadCityData(closure: ((Bool, Any?)->())?) {
    DispatchQueue.global().async {
        guard let path = Bundle(for: SwiftyCityPickerView.classForCoder()).path(forResource: "SwiftyCity", ofType: "bundle") else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        guard let bundle = Bundle(path: path) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        guard let cityPath = bundle.path(forResource: "city", ofType: "json") else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        let fileURLWithPath = URL(fileURLWithPath: cityPath)
        
        guard let cityData = try? Data(contentsOf: fileURLWithPath) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        
        guard let cityDatas = try? JSONSerialization.jsonObject(with: cityData, options: .mutableContainers) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        DispatchQueue.main.async {
            closure?(true, cityDatas)
        }
    }
}


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
    
}


extension SwiftyCityPickerView {
    @discardableResult override func show(doneClosure: SwiftyPickerDoneClosure?) -> Bool {
        guard super.show(doneClosure: doneClosure) else { return false }
        
        self.pickerView.isHidden = true
        self.toolBar.isHidden = true
        
        self.addSubview(self.loadingView)
        self.loadingView.frame = self.bounds
        self.loadingView.startAnimating()
        
        SwiftyCityPickerLoadCityData { (isSuccess, cityData) in
            
        }
        
        
        return true
    }
    override func dismiss() {
        super.dismiss()
    }
}


extension SwiftyCityPickerView {
    
}
