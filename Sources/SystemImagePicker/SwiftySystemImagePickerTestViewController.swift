//
//  SwiftySystemImagePickerTestViewController.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftySystemImagePickerTestViewController: UIViewController {

    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var pickerButton: UIButton = {
        let pickerButton = UIButton(type: .system)
        pickerButton.setTitle("Picker Button", for: .normal)
        pickerButton.setTitleColor(.white, for: .normal)
        pickerButton.backgroundColor = .gray
        pickerButton.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        return pickerButton
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.pickerButton)
        self.pickerButton.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        self.pickerButton.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
    }
    
    private func formatString<T>(value: T) -> String? {
        guard let data = String(format: "%@", value as! CVarArg).data(using: .utf8) else { return nil }
        guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
        return "\(utf8)"
    }
}

extension SwiftySystemImagePickerTestViewController {
    @objc func showAction() {
        SwiftySystemImagePicker.show(targetViewController: self, title: nil, message: nil, preferredStyle: .actionSheet, albumTitle: "Album", cameraTitle: "Camera", cancelTitle: "Cancel") { [weak self] (image, info) in
            guard let self = self else { return }
            
            print("\(self.formatString(value: image) ?? "")")
            print("\(self.formatString(value: info) ?? "")")
            
        }
    }
}
