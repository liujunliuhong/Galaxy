//
//  GLDatingEulaViewController.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit

private let defaultContent = "In order to have a better chatting place. please obey the following rules:\nHealthy chatting: chatting content includes all, except insult ,flirt,sexual,harassing messages,or like the same. Serious violation will get account banned.\nReport: Any bad behavior, please report to us.\nVisible Content: Do not tell others your privacy.\nDating Matters: If you start to meet frinds,please choose public places.\nPolice: When in danger or threatened in anappointment, please contact local police.";

fileprivate class GLDatingEulaViewController: UIViewController {

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .left
        return textView
    }()
    
    private lazy var agreeButton: UIButton = {
        let agreeButton = UIButton(type: .custom)
        agreeButton.contentMode = .scaleAspectFit
        agreeButton.setTitle("I AGREE", for: .normal)
        agreeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        agreeButton.setTitleColor(.white, for: .normal)
        agreeButton.layer.cornerRadius = 5.0
        agreeButton.layer.shadowColor = UIColor.black.cgColor
        agreeButton.layer.shadowOpacity = 0.6
        agreeButton.layer.shadowRadius = 2.0
        agreeButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        agreeButton.addTarget(self, action: #selector(agreeAction), for: .touchUpInside)
        agreeButton.backgroundColor = UIColor(red: 254/255.0, green: 189/255.0, blue: 0/255.0, alpha: 1)
        return agreeButton
    }()
    
    private let content: String
    
    init(content: String?) {
        if let content = content, content.count > 0 {
            self.content = content
        } else {
            self.content = defaultContent
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.textView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        let atr = NSMutableAttributedString(string: self.content)
        atr.gl_atr
            .add(font: UIFont.systemFont(ofSize: 17))
            .add(textColor: UIColor.black)
            .add(lineSpacing: 10)
        self.textView.attributedText = atr
        
        self.view.addSubview(self.agreeButton)
        self.view.addSubview(self.textView)
        
        self.agreeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-UIDevice.gl_homeIndicatorHeight - 25)
            make.height.equalTo(50)
        }
        self.textView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.agreeButton.snp.top)
            make.top.equalToSuperview().offset(UIDevice.gl_statusBarHeight + 44.0)
        }
    }
    
    @objc private func agreeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

fileprivate class _Navi: UINavigationController {
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarUpdateAnimation
        }
        return self.viewControllers.last?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    override var childForStatusBarHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var childForStatusBarStyle: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarStyle
        }
        return self.viewControllers.last?.preferredStatusBarStyle ?? .lightContent
    }
    
    override var shouldAutorotate: Bool {
        if let childVC = self.topViewController?.children.last {
            return childVC.shouldAutorotate
        }
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let childVC = self.topViewController?.children.last {
            return childVC.supportedInterfaceOrientations
        }
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredInterfaceOrientationForPresentation
        }
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}


public class GLDatingEULA {
    /// 显示`EULA`。如果`content`为`nil`，将使用默认的`content`。
    public static func show(content: String?, viewController: UIViewController?) {
        let vc = GLDatingEulaViewController(content: content)
        let navi = _Navi(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        viewController?.present(navi, animated: true, completion: nil)
    }
}
