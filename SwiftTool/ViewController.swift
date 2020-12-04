//
//  ViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SnapKit


fileprivate class Node: ASDisplayNode {
    
    lazy var node: ASDisplayNode = {
        let node = ASDisplayNode()
        node.style.height = ASDimensionMake(120)
        node.backgroundColor = .purple
        return node
    }()
    
    override init() {
        super.init()
        self.backgroundColor = .red
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spec1 = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [self.node])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), child: spec1)
    }
}


fileprivate class AlertView: UIView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题"
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = .red
        return titleLabel
    }()
    
    lazy var tagView: UIView = {
        let tagView = UIView()
        tagView.backgroundColor = .purple
        return tagView
    }()
    
    lazy var rightLabel: UILabel = {
        let rightLabel = UILabel()
        rightLabel.backgroundColor = .magenta
        rightLabel.text = "来啊来啊"
        rightLabel.numberOfLines = 0
        return rightLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        self.backgroundColor = .orange
        self.addSubview(self.titleLabel)
        self.addSubview(self.tagView)
        self.addSubview(self.rightLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalTo(self.tagView)
        }
        self.tagView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.width.height.equalTo(100)
            make.bottom.equalTo(self).offset(-20)
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.tagView)
            make.left.equalTo(self.tagView.snp.right).offset(20)
            make.width.equalTo(50)
            make.right.equalTo(self).offset(-10)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
}


fileprivate class Model: NSObject {
    
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo"
        self.view.backgroundColor = .white
        
        let options: GLSystemFaceKeyboardOptions = GLSystemFaceKeyboardOptions()
        let faceKyboardSize: CGSize = CGSize(width: 300, height: 150)
        let keyboard = GLSystemFaceKeyboard(keyboardSize: faceKyboardSize, options: options)
        keyboard.backgroundColor = .orange
        keyboard.delegate = self
        self.view.addSubview(keyboard)
        
        keyboard.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(faceKyboardSize)
        }
        
        let label = UILabel()
        label.glc
            .text("")
            .textColor(nil)
            .backgroundColor(nil)
            .layer
            .cornerRadius(2)
            //.view?
            //.text("")
        
        
//
//
//        let sort = SwiftyWordsSort<Model>()
//        let result = SwiftyWordsSort.getFirstEnglishWords(string: " ,.,;'!@#$%^&*() 嘻嘻哈哈啦啦abc ")
//        print("\(result)")
    }
}


extension ViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let vc = SwiftyBMKLocationTestViewController(bmk_key: bmk_key)
        //let vc = SwiftyNativeLocationTestViewController()
        //let vc = SwiftyAMapLocationTestViewController(amap_key: amap_key)
//        let vc = SwiftyQCloudCOSManagerTestViewController(appID: tencent_uplaod_appID, regionName: tencent_uplaod_regionName, secretID: tencent_uplaod_secretID, secretKey: tencent_uplaod_secretKey, bucketName: tencent_upload_bucketName)
        //let vc = SwiftyCusNavigationBarTestViewController(testImage: UIImage(named: "item_Image_1"))
        //self.navigationController?.pushViewController(vc, animated: true)
        
        
        //print("\(UIDevice.YH_Width)")
        
        
        
        
        /*
         let normalImages: [UIImage?] = [UIImage(named: "chats_normal"),
         UIImage(named: "photo_big"),
         UIImage(named: "discover_normal"),
         UIImage(named: "me_normal")]
         
         let selectImages: [UIImage?] = [UIImage(named: "chats_selected"),
         UIImage(named: "photo_big"),
         UIImage(named: "discover_selected"),
         UIImage(named: "me_selected")]
         let titles: [String] = ["聊天",
         "联系人",
         "发现",
         "我的"]
         
         let vc = SwiftyTabBarDemoProvider.demo(images: normalImages, selectImages: selectImages, titles: titles)
         self.navigationController?.pushViewController(vc, animated: true)
         */
        
        //let vc = SwiftyCusNavigationBarTestViewController(testImage: UIImage(named: "item_Image_1"))
        //self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = GLCusNavigationBarDemoViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
//        let node = Node()
//        GLAlert.default.show(node: node, containerWidth: 180, from: .topCenter(bottom: 0), to: .center, dismissTo: .bottomCenter(top: 0))
        
//        let alertView = AlertView()
//        GLAlert.default.show(view: alertView, from: .rightCenter(left: 0), to: .center, dismissTo: .bottomCenter(top: 0))
        
        let options = GLDatingMessageNotificationOptions()
        options.backgroundColor = .purple
        options.content = "akjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfjakjhdksdhfkhsdfj"
        options.title = "hellohellohellohellohellohellohellohellohellohellohellohello"
        
        GLDatingMessageNotificationManager.default.show(options: options, from: .bottomCenter(top: 0), to: .bottomCenter(bottom: 50))
        
    }
}


extension ViewController: GLSystemFaceKeyboardDelegate {
    func systemFaceKeyboard(_ systemFaceKeyboard: GLSystemFaceKeyboard, didSelectFace face: String) {
        GLLog("选中表情:\(face)")
    }
    
    func systemFaceKeyboardDidClickDelete(_ systemFaceKeyboard: GLSystemFaceKeyboard) {
        GLLog("删除表情")
    }
    
    
}
