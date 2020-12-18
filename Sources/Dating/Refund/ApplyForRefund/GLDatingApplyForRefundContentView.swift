//
//  GLDatingApplyForRefundContentView.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

private let buttonHeight: CGFloat = 44.0

internal class GLDatingApplyForRefundContentView: UIView {
    
    lazy var accountTextField: GLDatingRefundTextField = {
        let accountTextField = GLDatingRefundTextField()
        accountTextField.placeholder = "Account"
        return accountTextField
    }()
    
    lazy var nameTextField: GLDatingRefundTextField = {
        let nameTextField = GLDatingRefundTextField()
        nameTextField.placeholder = "Name"
        return nameTextField
    }()
    
    lazy var reasonTextView: GLDatingRefundTextView = {
        let reasonTextView = GLDatingRefundTextView()
        reasonTextView.placeholder = "Reason for refund"
        return reasonTextView
    }()
    
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.layer.cornerRadius = buttonHeight / 2.0
        submitButton.layer.masksToBounds = true
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.backgroundColor = GLDatingRefundOptions?.buttonColor
        return submitButton
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.backgroundColor = .gl_clear
        return cancelButton
    }()
    
    private let viewModel: GLDatingApplyForRefundViewModel
    init(viewModel: GLDatingApplyForRefundViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.addSubview(self.accountTextField)
        self.addSubview(self.nameTextField)
        self.addSubview(self.reasonTextView)
        self.addSubview(self.submitButton)
        self.addSubview(self.cancelButton)
        
        self.accountTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(50)
        }
        self.nameTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.accountTextField)
            make.top.equalTo(self.accountTextField.snp.bottom).offset(15)
        }
        self.reasonTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.accountTextField)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(15)
            make.height.equalTo(150)
        }
        self.submitButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.accountTextField)
            make.top.equalTo(self.reasonTextView.snp.bottom).offset(35)
            make.height.equalTo(buttonHeight)
        }
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.accountTextField)
            make.top.equalTo(self.submitButton.snp.bottom).offset(15)
            make.height.equalTo(buttonHeight)
        }
        
        self.submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.endEditing(true)
            self.viewModel.account = self.accountTextField.text
            self.viewModel.name = self.nameTextField.text
            self.viewModel.reason = self.reasonTextView.text
            self.viewModel.clickSubmitTrigger.onNext(())
        }).disposed(by: rx.disposeBag)
        
        self.cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.endEditing(true)
            self.viewModel.clickCancelTrigger.onNext(())
        }).disposed(by: rx.disposeBag)
    }
    
}
