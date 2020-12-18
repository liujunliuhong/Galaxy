//
//  GLDatingRefundSuccessView.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

private let buttonHeight: CGFloat = 44.0

internal class GLDatingRefundSuccessView: UIView {
    
    private lazy var successImageView: UIImageView = {
        let successImageView = UIImageView()
        successImageView.image = GLDatingRefundOptions?.successImage
        successImageView.contentMode = .scaleAspectFit
        return successImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = GLDatingRefundOptions?.textColor
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var clickDoneClosure: (() -> Void)?
    
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.layer.cornerRadius = buttonHeight / 2.0
        doneButton.layer.masksToBounds = true
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(GLDatingRefundOptions?.textColor, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        doneButton.backgroundColor = GLDatingRefundOptions?.buttonColor
        return doneButton
    }()
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.addSubview(self.successImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.doneButton)
        
        self.successImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-130)
            make.width.height.equalTo(100)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.successImageView.snp.bottom).offset(35)
        }
        
        self.doneButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(50)
            make.height.equalTo(buttonHeight)
        }
        
        self.doneButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.clickDoneClosure?()
        }).disposed(by: rx.disposeBag)
    }
}
