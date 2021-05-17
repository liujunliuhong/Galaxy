//
//  GLDatingRefundAlert.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SnapKit

internal var GLDatingRefundOptions: GLDatingRefundAlertOptions?

private let buttonHeight: CGFloat = 44.0
private let inset = UIEdgeInsets(top: 34.5, left: 40, bottom: 15.0 + UIDevice.gl_homeIndicatorHeight, right: 40)

public class GLDatingRefundAlert: UIView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Contact Us"
        titleLabel.textAlignment = .left
        titleLabel.textColor = GLDatingRefundOptions?.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        return titleLabel
    }()
    
    private lazy var refundButton: UIButton = {
        let refundButton = UIButton(type: .custom)
        refundButton.layer.cornerRadius = buttonHeight / 2.0
        refundButton.layer.masksToBounds = true
        refundButton.setTitle("Apply for Refund", for: .normal)
        refundButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        refundButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        refundButton.backgroundColor = GLDatingRefundOptions?.buttonColor
        return refundButton
    }()
    
    private lazy var suggestionsButton: UIButton = {
        let suggestionsButton = UIButton(type: .custom)
        suggestionsButton.layer.cornerRadius = buttonHeight / 2.0
        suggestionsButton.layer.masksToBounds = true
        suggestionsButton.setTitle("Make Suggestions", for: .normal)
        suggestionsButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        suggestionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        suggestionsButton.backgroundColor = GLDatingRefundOptions?.buttonColor
        return suggestionsButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.backgroundColor = .gl_clear
        return cancelButton
    }()
    
    private var clickRefundClosure: (() -> Void)?
    private var clickSuggestionsClosure: (() -> Void)?
    private var clickCancelClosure: (() -> Void)?
    
    private init() {
        super.init(frame: .zero)
        initData()
        setupUI()
        bindViewModel()
        other()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GLDatingRefundAlert {
    private func initData() {
        self.backgroundColor = GLDatingRefundOptions?.backgroundColor
    }
    
    private func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.refundButton)
        self.addSubview(self.suggestionsButton)
        self.addSubview(self.cancelButton)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(inset.top)
            make.right.equalToSuperview().offset(-5)
        }
        self.refundButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(inset.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(35)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(UIDevice.gl_width - inset.left - inset.right)
            make.right.equalTo(self).offset(-inset.right)
        }
        self.suggestionsButton.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.refundButton)
            make.top.equalTo(self.refundButton.snp.bottom).offset(15.5)
        }
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.refundButton)
            make.top.equalTo(self.suggestionsButton.snp.bottom).offset(15.5)
            make.bottom.equalTo(self).offset(-inset.bottom)
        }
    }
    
    private func bindViewModel() {
        self.refundButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.clickRefundClosure?()
        }).disposed(by: rx.disposeBag)
        
        self.suggestionsButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.clickSuggestionsClosure?()
        }).disposed(by: rx.disposeBag)
        
        self.cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.clickCancelClosure?()
        }).disposed(by: rx.disposeBag)
    }
    
    private func other() {
        
    }
}


extension GLDatingRefundAlert {
    public static func show(viewController: UIViewController?,
                            options: GLDatingRefundAlertOptions = GLDatingRefundAlertOptions()) {
        GLDatingRefundOptions = options
        
        let refundView = GLDatingRefundAlert()
        
        refundView.clickCancelClosure = {
            GLAlert.default.dismiss()
        }
        
        refundView.clickRefundClosure = {
            options.clickRefundClosure?()
            GLAlert.default.dismiss()
            
            let refundVC = GLDatingApplyForRefundViewController()
            refundVC.refundSendSuccessClosure = options.refundSendSuccessClosure
            let navi = _Navi(rootViewController: refundVC)
            navi.modalPresentationStyle = .fullScreen
            viewController?.present(navi, animated: true, completion: nil)
        }
        
        refundView.clickSuggestionsClosure = {
            options.clickSuggestionsClosure?()
            GLAlert.default.dismiss()
            
            let suggestionsVC = GLDatingRefundMakeSuggestionsViewController()
            suggestionsVC.suggestionsSendSuccessClosure = options.suggestionsSendSuccessClosure
            let navi = _Navi(rootViewController: suggestionsVC)
            navi.modalPresentationStyle = .fullScreen
            viewController?.present(navi, animated: true, completion: nil)
        }
        
        
        let options = GLAlertOptions(from: .bottomCenter(top: 0), to: .bottomCenter(bottom: 0), dismissTo: .bottomCenter(top: 0))
        options.shouldResignOnTouchOutside = true
        options.translucentColor = UIColor.gl_black.withAlphaComponent(0.5)
        GLAlert.default.show(view: refundView, options: options)
    }
}


fileprivate class _Navi: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [.foregroundColor: (GLDatingRefundOptions?.textColor ?? .white),
                                                  .font: UIFont.boldSystemFont(ofSize: 18)]
        self.navigationBar.barTintColor = GLDatingRefundOptions?.backgroundColor
        self.navigationBar.tintColor = GLDatingRefundOptions?.textColor
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.shadowImage = GLDatingRefundOptions?.backgroundColor.gl_toImage()
    }
    
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
