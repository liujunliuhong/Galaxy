//
//  SwiftyTagContainerTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate let leftMargin: CGFloat = 20.0
fileprivate let rightMargin: CGFloat = 20.0
fileprivate let containerWidth: CGFloat = UIScreen.main.bounds.width - leftMargin - rightMargin
fileprivate let tagHeight: CGFloat = 35.0

fileprivate var RandomColor: UIColor {
    let R: CGFloat = CGFloat(arc4random() % 255)
    let G: CGFloat = CGFloat(arc4random() % 255)
    let B: CGFloat = CGFloat(arc4random() % 255)
    let A: CGFloat = 1.0
    return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
}

fileprivate class TagButton: UIButton {
    
}

extension TagButton: SwiftyTagContainerProtocol {
    func tagView() -> UIView {
        return self
    }
    
    func tagWidth() -> CGFloat {
        self.sizeToFit()
        return self.frame.width + 10.0
    }
}



public class SwiftyTagContainerTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    
    private lazy var dataSource: [String] = {
        return ["123",
                "sdkfsjdf",
                "啊好多事件回调",
                "1",
                "osdfjsodi",
                "293]wpe/.''-",
                "阿善动isU盾分为地粉红色的",
                "ifsdiofusidufiosdufiousdofuisodufoisudiofusdioufwuerouewoir",
                "as世界第三见覅就斯蒂芬is的缴费is的",
                "sdifjsdoifjiodsfios",
                "as",
                "sad",
                "qwewq",
                "空间发大煞风景哈萨克大家好福克斯绝代风华Allstate",
                "kjkjdsfjhdsjhfjksd可点击看房哈山东矿机风寒咳嗽的交话费数据库地粉红色的后访客时代峻峰",
                "sdjfisdj",
                "a"]
    }()
    
    private lazy var tagContainerView: SwiftyTagContainerView = {
        let tagContainerView = SwiftyTagContainerView(with: containerWidth, tagHeight: tagHeight, lineSpace: 10.0, columnSpace: 10.0)
        tagContainerView.backgroundColor = .orange
        return tagContainerView
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.tagContainerView)
        
        var frame = CGRect(x: leftMargin, y: 44.0 + UIApplication.shared.statusBarFrame.height + 20.0, width: containerWidth, height: .zero)
        self.tagContainerView.frame = frame
        
        var buttons: [TagButton] = []
        for (_, string) in self.dataSource.enumerated() {
            let button = TagButton(type: .custom)
            button.backgroundColor = RandomColor
            button.setTitle(string, for: .normal)
            button.setTitleColor(.black, for: .normal)
            buttons.append(button)
        }
        
        let containerHeight = self.tagContainerView.reload(with: buttons)
        
        frame.size.height = containerHeight
        self.tagContainerView.frame = frame
    }
}
