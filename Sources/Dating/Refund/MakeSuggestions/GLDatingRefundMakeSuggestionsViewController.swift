//
//  GLDatingRefundMakeSuggestionsViewController.swift
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

public class GLDatingRefundMakeSuggestionsViewController: UIViewController {

    private lazy var viewModel: GLDatingRefundMakeSuggestionsViewModel = {
        let viewModel = GLDatingRefundMakeSuggestionsViewModel()
        return viewModel
    }()
    
    private lazy var successView: GLDatingRefundSuccessView = {
        let successView = GLDatingRefundSuccessView()
        successView.title = "Thanks for your suggestions."
        successView.isHidden = true
        return successView
    }()
    
    private lazy var contentView: GLDatingRefundMakeSuggestionsContentView = {
        let contentView = GLDatingRefundMakeSuggestionsContentView(viewModel: self.viewModel)
        contentView.isHidden = false
        return contentView
    }()
    
    public var suggestionsSendSuccessClosure: (() -> Void)?
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Apply for Refund"
        self.view.backgroundColor = GLDatingRefundOptions?.backgroundColor
        self.edgesForExtendedLayout = [.left, .right, .bottom]
        
        self.view.addSubview(self.successView)
        self.view.addSubview(self.contentView)
        self.successView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.successView.clickDoneClosure = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.clickCancelTrigger.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
        
        self.viewModel.submitSuccessTrigger.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.successView.isHidden = false
            self.contentView.isHidden = true
            self.suggestionsSendSuccessClosure?()
        }).disposed(by: rx.disposeBag)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    public override var shouldAutorotate: Bool {
        return false
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
