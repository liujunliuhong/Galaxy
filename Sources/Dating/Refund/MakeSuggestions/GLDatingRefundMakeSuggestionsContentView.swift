//
//  GLDatingRefundMakeSuggestionsContentView.swift
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

internal class GLDatingRefundMakeSuggestionsContentView: UIView {
    
    lazy var suggestionsTextView: GLDatingRefundTextView = {
        let suggestionsTextView = GLDatingRefundTextView()
        suggestionsTextView.placeholder = "Enter suggestions"
        return suggestionsTextView
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
    
    private let viewModel: GLDatingRefundMakeSuggestionsViewModel
    init(viewModel: GLDatingRefundMakeSuggestionsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.addSubview(self.suggestionsTextView)
        self.addSubview(self.submitButton)
        self.addSubview(self.cancelButton)
        
        self.suggestionsTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(150)
        }
        self.submitButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.suggestionsTextView)
            make.top.equalTo(self.suggestionsTextView.snp.bottom).offset(35)
            make.height.equalTo(buttonHeight)
        }
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.suggestionsTextView)
            make.top.equalTo(self.submitButton.snp.bottom).offset(15)
            make.height.equalTo(buttonHeight)
        }
        
        self.submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.endEditing(true)
            self.viewModel.suggestions = self.suggestionsTextView.text
            self.viewModel.clickSubmitTrigger.onNext(())
        }).disposed(by: rx.disposeBag)
        
        self.cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.endEditing(true)
            self.viewModel.clickCancelTrigger.onNext(())
        }).disposed(by: rx.disposeBag)
    }
    
}
