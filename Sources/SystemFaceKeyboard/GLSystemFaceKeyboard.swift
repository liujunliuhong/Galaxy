//
//  GLSystemFaceKeyboard.swift
//  SwiftTool
//
//  Created by galaxy on 2020/11/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public protocol GLSystemFaceKeyboardDelegate: NSObjectProtocol {
    func systemFaceKeyboard(_ systemFaceKeyboard: GLSystemFaceKeyboard, didSelectFace face: String)
    func systemFaceKeyboardDidClickDelete(_ systemFaceKeyboard: GLSystemFaceKeyboard)
}

public class GLSystemFaceKeyboard: UIView {
    
    public private(set) lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.gl_rgba(R: 153, G: 153, B: 153)
        pageControl.pageIndicatorTintColor = UIColor.gl_rgba(R: 153, G: 153, B: 153).withAlphaComponent(0.3)
        pageControl.isUserInteractionEnabled = false
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
        }
        return pageControl
    }()
    
    public private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GLSystemFaceKeyboardCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(GLSystemFaceKeyboardCell.classForCoder()))
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = self._clerColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public let keyboardSize: CGSize
    public let options: GLSystemFaceKeyboardOptions
    
    private let _clerColor: UIColor = UIColor.gl_rgba(R: 0, G: 0, B: 0).withAlphaComponent(0)
    private var dataSource: [[AnyObject]] = []
    
    public weak var delegate: GLSystemFaceKeyboardDelegate?
    
    public init(keyboardSize: CGSize, options: GLSystemFaceKeyboardOptions) {
        self.keyboardSize = keyboardSize
        self.options = options
        super.init(frame: .zero)
        initUI()
        setupUI()
        loadData()
    }
    
    private override init(frame: CGRect) {
        self.keyboardSize = .zero
        self.options = GLSystemFaceKeyboardOptions()
        super.init(frame: frame)
        initUI()
        setupUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GLSystemFaceKeyboard {
    private func initUI() {
        self.backgroundColor = _clerColor
    }
    
    private func setupUI() {
        
    }
    
    private func loadData() {
        GL_GetAllSystemEmojis(row: self.options.row, column: self.options.column) { [weak self] (dataSource) in
            guard let self = self else { return }
            self.addSubview(self.pageControl)
            self.addSubview(self.collectionView)
            
            self.dataSource = dataSource
            
            self.pageControl.numberOfPages = dataSource.count
            
            let pageControlSize = self.pageControl.size(forNumberOfPages: dataSource.count)
            
            self.pageControl.frame = CGRect(x: (self.keyboardSize.width - pageControlSize.width) / 2.0,
                                            y: self.keyboardSize.height - self.options.indicatorInset.bottom - pageControlSize.height,
                                            width: pageControlSize.width,
                                            height: pageControlSize.height)
            
            
            let collectionViewSize: CGSize = CGSize(width: self.keyboardSize.width,
                                                    height: self.keyboardSize.height - self.options.indicatorInset.bottom - self.options.indicatorInset.top - pageControlSize.height)
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = .zero
            layout.minimumLineSpacing = .zero
            layout.minimumInteritemSpacing = .zero
            layout.itemSize = collectionViewSize
            layout.scrollDirection = .horizontal
            self.collectionView.frame = CGRect(origin: .zero, size: collectionViewSize)
            self.collectionView.collectionViewLayout = layout
            
            self.collectionView.reloadData()
        }
    }
}

extension GLSystemFaceKeyboard: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(GLSystemFaceKeyboardCell.classForCoder()), for: indexPath) as?GLSystemFaceKeyboardCell else { return UICollectionViewCell() }
        cell.reload(options: self.options, faces: self.dataSource[indexPath.item])
        cell.clickFaceClosure = { [weak self] (face) in
            guard let self = self else { return }
            self.delegate?.systemFaceKeyboard(self, didSelectFace: face.value)
        }
        cell.clickDeleteClosure = { [weak self] in
            guard let self = self else { return }
            self.delegate?.systemFaceKeyboardDidClickDelete(self)
        }
        return cell
    }
}

extension GLSystemFaceKeyboard: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(roundf(Float(abs(scrollView.contentOffset.x / self.keyboardSize.width))))
        self.pageControl.currentPage = index
    }
}

