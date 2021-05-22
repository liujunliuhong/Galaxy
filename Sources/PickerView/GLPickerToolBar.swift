//
//  GLPickerToolBar.swift
//  PickerView
//
//  Created by galaxy on 2020/10/25.
//

import UIKit

/// 内置的ToolBar
public class GLPickerToolBar: UIView {
    
    public private(set) lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.setTitle("Cancel", for: .normal)
        return cancelButton
    }()
    
    public private(set) lazy var sureButton: UIButton = {
        let sureButton = UIButton(type: .system)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sureButton.setTitle("Done", for: .normal)
        return sureButton
    }()
    
    public private(set) lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    public var cancelButtonWidth: CGFloat = .zero
    public var sureButtonWidth: CGFloat = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var _sureButtonWidth: CGFloat = .zero
        var _cancelButtonWidth: CGFloat = .zero
        if !sureButtonWidth.isLessThanOrEqualTo(.zero) {
            _sureButtonWidth = sureButtonWidth
        } else {
            sureButton.sizeToFit()
            _sureButtonWidth = sureButton.frame.width
        }
        if !cancelButtonWidth.isLessThanOrEqualTo(.zero) {
            _cancelButtonWidth = cancelButtonWidth
        } else {
            cancelButton.sizeToFit()
            _cancelButtonWidth = cancelButton.frame.width
        }
        
        var leftDistance: CGFloat = .zero
        if !_cancelButtonWidth.isLessThanOrEqualTo(.zero) {
            cancelButton.frame = CGRect(x: 10, y: 0, width: _cancelButtonWidth, height: frame.height)
            leftDistance = cancelButton.frame.maxX
        }
        
        var rightDistance: CGFloat = .zero
        if !_sureButtonWidth.isLessThanOrEqualTo(.zero) {
            sureButton.frame = CGRect(x: frame.width - _sureButtonWidth - 10, y: 0, width: _sureButtonWidth, height: frame.height)
            rightDistance = frame.width - sureButton.frame.minX
        }
        
        let distance: CGFloat = max(leftDistance, rightDistance)
        
        let titleWidth = frame.width - 2.0 * distance
        self.titleLabel.frame = CGRect(x: distance, y: 0, width: titleWidth, height: frame.height)
    }
}


extension GLPickerToolBar {
    private func setupUI() {
        addSubview(cancelButton)
        addSubview(sureButton)
        addSubview(titleLabel)
    }
}

