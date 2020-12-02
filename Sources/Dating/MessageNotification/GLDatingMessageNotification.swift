//
//  GLDatingMessageNotification.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let indicatorHeight: CGFloat = 6.0

internal class GLDatingMessageNotification: UIView {

    lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.layer.cornerRadius = indicatorHeight / 2.0
        indicatorView.layer.masksToBounds = true
        return indicatorView
    }()
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        return contentLabel
    }()
    
    lazy var rightStackView: UIStackView = {
        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.spacing = 4.0
        rightStackView.distribution = .fill
        return rightStackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 10.0
        contentStackView.distribution = .fill
        return contentStackView
    }()
    
    let options: GLDatingMessageNotificationOptions
    var timer: Timer?
    var tapDismissClosure: ((GLDatingMessageNotification)->())?
    var autoDismissClosure: ((GLDatingMessageNotification)->())?
    
    
    init(options: GLDatingMessageNotificationOptions) {
        self.options = options
        super.init(frame: .zero)
        initUI()
        setupUI()
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GLDatingMessageNotification {
    func initUI() {
        self.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipe.direction = .down
        self.addGestureRecognizer(swipe)
    }
    
    func setupUI() {
        self.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7.5)
            make.width.equalTo(56.5)
            make.height.equalTo(indicatorHeight)
        }
        
        if self.options.title != nil && self.options.title!.count > 0 {
            self.rightStackView.addArrangedSubview(self.titleLabel)
        }
        if self.options.content != nil && self.options.content!.count > 0 {
            self.rightStackView.addArrangedSubview(self.contentLabel)
        }
        
        self.contentStackView.addArrangedSubview(self.avatarImageView)
        self.contentStackView.addArrangedSubview(self.rightStackView)
        
        self.avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.options.avatarHeight)
        }
        
        self.addSubview(self.contentStackView)
        
        let offset: CGFloat = 10.0
        self.contentStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(offset)
            make.width.equalTo(self.options.containerWidth - offset - offset)
            make.top.equalTo(self.indicatorView.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-10) // 底部约束
            make.right.equalTo(self).offset(-offset) // 右边约束
        }
    }
    
    func setData() {
        self.backgroundColor = self.options.backgroundColor
        self.layer.cornerRadius = self.options.cornerRadius
        if let remoteURL = options.remoteAvatarURLString {
            self.avatarImageView.sd_setImage(with: URL(string: remoteURL), placeholderImage: self.options.defaultAvatarImage)
        } else if let localAvatar = options.localAvatar {
            self.avatarImageView.image = localAvatar
        } else {
            self.avatarImageView.image = self.options.defaultAvatarImage
        }
        self.avatarImageView.layer.cornerRadius = self.options.avatarHeight / 2.0
        self.indicatorView.backgroundColor = self.options.indicatorColor
        self.titleLabel.text = self.options.title
        self.titleLabel.textColor = self.options.titleColor
        self.titleLabel.font = self.options.titleFont
        self.contentLabel.text = self.options.content
        self.contentLabel.textColor = self.options.contentColor
        self.contentLabel.font = self.options.contentFont
    }
}

extension GLDatingMessageNotification {
    @objc func autoDismissTimerAction() {
        self.autoDismissClosure?(self)
    }
    
    @objc func swipeAction() {
        self.timer?.invalidate()
        self.autoDismissClosure?(self)
    }
    
    @objc private func tapAction() {
        self.timer?.invalidate()
        self.tapDismissClosure?(self)
    }
}

extension GLDatingMessageNotification {
    /// 添加定时器
    func addTimer() {
        let timer = Timer(timeInterval: 2, target: GLWeakProxy(target: self), selector: #selector(autoDismissTimerAction), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
}
