//
//  SwiftyPickerTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyPickerTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var commonPickerButton: UIButton = {
        let commonPickerButton = UIButton(type: .system)
        commonPickerButton.setTitle("Common Picker", for: .normal)
        commonPickerButton.setTitleColor(.white, for: .normal)
        commonPickerButton.backgroundColor = .gray
        commonPickerButton.addTarget(self, action: #selector(commonPickerAction), for: .touchUpInside)
        return commonPickerButton
    }()
    
    private lazy var datePickerButton: UIButton = {
        let datePickerButton = UIButton(type: .system)
        datePickerButton.setTitle("Date Picker", for: .normal)
        datePickerButton.setTitleColor(.white, for: .normal)
        datePickerButton.backgroundColor = .gray
        datePickerButton.addTarget(self, action: #selector(datePickerAction), for: .touchUpInside)
        return datePickerButton
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.commonPickerButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.datePickerButton.frame = CGRect(x: leftMargin, y: self.commonPickerButton.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.commonPickerButton)
        self.view.addSubview(self.datePickerButton)
    }
}


extension SwiftyPickerTestViewController {
    @objc func commonPickerAction() {
        
    }
    
    @objc func datePickerAction() {
        
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}
