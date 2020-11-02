//
//  GLSystemFaceKeyboardCell.swift
//  SwiftTool
//
//  Created by galaxy on 2020/11/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


fileprivate class _ItemView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
        self.imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        self.imageView.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
    }
    func setupUI() {
        self.addSubview(self.label)
        self.addSubview(self.imageView)
    }
    func set(face: AnyObject) {
        if let emojiModel = face as? GLSystemFace {
            self.imageView.isHidden = true
            self.label.isHidden = false
            self.label.text = emojiModel.value
        } else if let delete = face as? GLSystemFaceDelete {
            self.imageView.isHidden = false
            self.label.isHidden = true
            self.imageView.image = delete.image
        } else {
            self.imageView.isHidden = true
            self.label.isHidden = true
        }
    }
}


internal class GLSystemFaceKeyboardCell: UICollectionViewCell {
    private let _clerColor: UIColor = UIColor.gl_rgba(R: 0, G: 0, B: 0).withAlphaComponent(0)
    private let baseTag: Int = 1000
    private var itemViews: [_ItemView] = []
    private var faces: [AnyObject] = []
    
    internal var clickFaceClosure: ((GLSystemFace)->())?
    internal var clickDeleteClosure: (()->())?
    
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = _clerColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GLSystemFaceKeyboardCell {
    internal func reload(options: GLSystemFaceKeyboardOptions, faces: [AnyObject]) {
        self.faces = faces
        
        for (_, view) in self.itemViews.enumerated() {
            view.removeFromSuperview()
        }
        self.itemViews.removeAll()
        
        assert(options.column > 0)
        assert(options.row > 0)
        
        var sumInteritemSpacing: CGFloat = .zero
        if !options.interitemSpacing.isLessThanOrEqualTo(.zero) {
            sumInteritemSpacing = CGFloat(options.column - 1) * options.interitemSpacing
        }
        
        var sumLineSpacing: CGFloat = .zero
        if !options.lineSpacing.isLessThanOrEqualTo(.zero) {
            sumLineSpacing = CGFloat(options.row - 1) * options.lineSpacing
        }
        
        
        var o_x: CGFloat = options.inset.left
        var o_y: CGFloat = options.inset.top
        let itemWidth: CGFloat = (self.bounds.width - options.inset.left - options.inset.right - sumInteritemSpacing) / CGFloat(options.column)
        let itemHeight: CGFloat = (self.bounds.height - options.inset.top - options.inset.bottom - sumLineSpacing) / CGFloat(options.row)
        assert(!itemHeight.isLessThanOrEqualTo(.zero))
        assert(!itemWidth.isLessThanOrEqualTo(.zero))
        
        
        for (i, face) in faces.enumerated() {
            if i % options.column == 0 && i > 0 {
                o_x = options.inset.left
                o_y += (itemHeight + options.lineSpacing)
            }
            let itemView = _ItemView()
            itemView.backgroundColor = self._clerColor
            itemView.label.backgroundColor = self._clerColor
            itemView.imageView.backgroundColor = self._clerColor
            itemView.tag = self.baseTag + i
            itemView.set(face: face)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(itemViewGestureAction(gesture:)))
            itemView.addGestureRecognizer(gesture)
            itemView.frame = CGRect(x: o_x, y: o_y, width: itemWidth, height: itemHeight)
            o_x += (itemWidth + options.interitemSpacing)
            self.addSubview(itemView)
            self.itemViews.append(itemView)
        }
    }
}

extension GLSystemFaceKeyboardCell {
    @objc private func itemViewGestureAction(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag - self.baseTag
        let model = self.faces[index]
        if let emojiModel = model as? GLSystemFace {
            self.clickFaceClosure?(emojiModel)
        } else if let _ = model as? GLSystemFaceDelete {
            self.clickDeleteClosure?()
        }
    }
}
