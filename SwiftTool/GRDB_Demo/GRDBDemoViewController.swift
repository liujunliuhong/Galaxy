//
//  GRDBDemoViewController.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/10.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import GRDB
import SnapKit

class GRDBDemoViewController: UIViewController {

    lazy var creatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("创建表", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var insertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("插入一个数据", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var queryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("查询", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更新", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        
        self.view.addSubview(self.creatButton)
        self.view.addSubview(self.insertButton)
        self.view.addSubview(self.queryButton)
        self.view.addSubview(self.updateButton)
        self.creatButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(120)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        self.insertButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(120)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        self.queryButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(self.creatButton.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        self.updateButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.creatButton.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        self.creatButton.addTarget(self, action: #selector(creatAction), for: .touchUpInside)
        self.insertButton.addTarget(self, action: #selector(insertAction), for: .touchUpInside)
        self.queryButton.addTarget(self, action: #selector(queryAction), for: .touchUpInside)
        self.queryButton.addTarget(self, action: #selector(updateAction), for: .touchUpInside)
        
        GLDatingMessageManager.default.conversationList.subscribe(onNext: { (conversationList) in
            for (_, conversation) in conversationList.enumerated() {
                GLLog("\(conversation.unReadCount)")
            }
        }).disposed(by: rx.disposeBag)
    }
}

let ownerID: String = "123"

extension GRDBDemoViewController {
    @objc func creatAction() {
        GLDatingMessageManager.default.register(ownerID: ownerID)
        GLDatingMessageManager.default.creatDataBase()
        GLDatingMessageManager.default.startListeningConversationList()
        GLDatingMessageManager.default.startListeningMessageUnreadCount()
//        let _ = GLDatingUserManager.default
    }
    
    @objc func insertAction() {
//        try? GLDatingUserManager.default.register(sex: .women, email: "222@", password: "123456", nickName: "lala")
//        let userInfo =  GLDatingMessageUserInfo()
//        userInfo.sender_id = "sender_id"
        
        let message = GLDatingMessageManager.default.sendMessage(conversationID: "111", messageType: .text, messageContent: "hello", isSender: true, isRead: false, userInfo: nil)
        
    }
    
    @objc func queryAction() {
        let message = GLDatingMessageManager.default.sendMessage(conversationID: "222", messageType: .text, messageContent: "hello", isSender: true, isRead: false, userInfo: nil)
//        try? GLDatingUserManager.default.loadUserInfo()
    }
    
    @objc func updateAction() {
//        GLDatingUserManager.default.updateUserNickName(nickName: "liujun__12345")
    }
}
