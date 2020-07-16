//
//  SwiftyLogTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyLogTestViewController: UIViewController {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var logButton: UIButton = {
        let logButton = UIButton(type: .system)
        logButton.setTitle("Start Print Log", for: .normal)
        logButton.setTitleColor(.white, for: .normal)
        logButton.backgroundColor = .gray
        logButton.addTarget(self, action: #selector(printLog), for: .touchUpInside)
        return logButton
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.logButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.view.addSubview(self.logButton)
    }
    
}

extension SwiftyLogTestViewController {
    @objc private func printLog() {
        SwiftyLog("Test Log.")
    }
}
