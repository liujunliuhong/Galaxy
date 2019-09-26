//
//  YHDragCard.swift
//  FNDating
//
//  Created by apple on 2019/9/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit


/// 数据源
protocol YHDragCardDataSource: NSObjectProtocol {
    func numberOfCount(_ dragCard: YHDragCard) -> Int
    func dragCard(_ dragCard: YHDragCard, indexOfCard: Int) -> UIView
}



/// 代理
protocol YHDragCardDelegate: NSObjectProtocol {
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int)
}


extension YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int) {}
}




/// 存储卡片的位置信息
struct YHDragCardInfo {
    let card: UIView
    let transform: CGAffineTransform
    let position: CGPoint
    init(card: UIView, transform: CGAffineTransform, position: CGPoint) {
        self.card = card
        self.transform = transform
        self.position = position
    }
}



class YHDragCard: UIView {
   
    weak var dataSource: YHDragCardDataSource?
    weak var delegate: YHDragCardDelegate?

    
    public var visibleCount: Int = 3
    public var cardSpacing: CGFloat = 10.0
    public var minScale: CGFloat = 0.8
    public var removeDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0
    public var removeVelocity: CGFloat = 1000.0
    
    
    private var currentIndex: Int = 0
    private var initialFirstCardCenter: CGPoint = .zero
    private var infos: [YHDragCardInfo] = [YHDragCardInfo]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        
    }
    
    @available(iOS, unavailable)
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        test()
    }
    
}

extension YHDragCard {
    func test() {
        
        self.infos.forEach { (transform) in
            transform.card.removeFromSuperview()
        }
        self.infos.removeAll()
        self.currentIndex = 0
        
        
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        
        if showCount <= 0 {
            return
        }
        
        if self.minScale > 1.0 {
            self.minScale = 1.0
        }
        if self.minScale <= 0 {
            self.minScale = 0.1
        }
        
        var scale: CGFloat = 1.0
        if showCount > 1 {
            scale = CGFloat(1.0 - self.minScale) / CGFloat(showCount - 1)
        }
        
        let cardWidth = self.bounds.size.width
        let cardHeight: CGFloat = self.bounds.size.height - CGFloat(showCount - 1) * self.cardSpacing
        
        for index in 0..<showCount {
            let y = cardSpacing * CGFloat(index)
            let frame = CGRect(x: 0, y: y, width: cardWidth, height: cardHeight)
            
            let tmpScale: CGFloat = 1.0 - (scale * CGFloat(index))
            let transform = CGAffineTransform(scaleX: tmpScale, y: tmpScale)
            
            let card = self.dataSource?.dragCard(self, indexOfCard: index)
            
            if let _card = card {
                _card.isUserInteractionEnabled = false
                _card.backgroundColor = UIColor.YH_RandomColor
                _card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                insertSubview(_card, at: 0)
                
                
                _card.transform = .identity
                _card.frame = frame
                _card.transform = transform
                
                let info = YHDragCardInfo(card: _card, transform: transform, position: _card.layer.position)
                self.infos.append(info)
                
                addPanGesture(for: _card)
                
                if index == 0 {
                    initialFirstCardCenter = _card.center
                }
            } else {
                fatalError("card不能为空")
            }
        }
        
        self.infos.first?.card.isUserInteractionEnabled = true
    }
    
    
    // 调用该方法的前提是剩余卡片数量要大于visibleCount
    func installNextCard() {
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        
        var scale: CGFloat = 1.0
        if showCount > 1 {
            scale = CGFloat(1.0 - self.minScale) / CGFloat(showCount - 1)
        }
        
        if self.currentIndex + 1 >= maxCount {
            fatalError("索引越界")
        }
        
        if showCount <= 0 {
            fatalError("`numberOfCount`或者`visibleCount`为0")
        }
        
        let card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex + 1)
        
        guard let _card = card else {
            fatalError("card不能为空")
        }
        
        let cardWidth = self.bounds.size.width
        let cardHeight: CGFloat = self.bounds.size.height - CGFloat(showCount - 1) * self.cardSpacing
        
        // 最底下那张卡片的frame
        let y = cardSpacing * CGFloat(showCount - 1)
        let frame = CGRect(x: 0, y: y, width: cardWidth, height: cardHeight)
        
        // 最底下那张卡片的transform
        let tmpScale: CGFloat = 1.0 - (scale * CGFloat(showCount - 1))
        let transform = CGAffineTransform(scaleX: tmpScale, y: tmpScale)
        
        _card.isUserInteractionEnabled = false
        _card.backgroundColor = UIColor.YH_RandomColor
        _card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        _card.frame = frame
        _card.transform = transform
        insertSubview(_card, at: 0)
        
        
        
        let info = YHDragCardInfo(card: _card, transform: transform, position: _card.layer.position)
        self.infos.append(info)
        
        addPanGesture(for: _card)
    }
    
    
    private func addPanGesture(for card: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        card.addGestureRecognizer(pan)
    }
}




extension YHDragCard {
    @objc func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
        guard let cardView = panGesture.view else { return }
        let movePoint = panGesture.translation(in: self)
        let velocity = panGesture.velocity(in: self)
        
        
        
        
        switch panGesture.state {
        case .began:
            print("begin")
            
            // 把下一张卡片添加到最底部
            installNextCard()
            
        case .changed:
            print("changed")
            let currentPoint = CGPoint(x: cardView.center.x + movePoint.x, y: cardView.center.y + movePoint.y)
            // 设置手指拖住的那张卡牌的位置
            cardView.center = currentPoint
            // 设置手指拖住的那张卡牌的旋转角度
            let angle: CGFloat = (CGFloat)(Double.pi/4) / 12.0
            let rotationAngle = (cardView.center.x - bounds.size.width / 2.0) / (bounds.size.width / 2.0) * angle
            cardView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            // 复位
            panGesture.setTranslation(.zero, in: self)
            // 卡牌变化
            let moveDistance: CGFloat = abs(cardView.center.x - initialFirstCardCenter.x)
            let ratio = moveDistance / removeDistance
            moving(ratio: ratio)
            
        case .ended:
            print("ended")
            
            
            
        case .cancelled, .failed:
            print("cancelled or failed")
            
            
            
            
        default:
            break
        }
    }
}




extension YHDragCard {
    func moving(ratio: CGFloat) {
        // 1、infos数量小于等于visibleCount
        // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
        var ratio = ratio
        if ratio < 0.0 {
            ratio = 0.0
        } else if ratio > 1.0 {
            ratio = 1.0
        }
        print("-----\(ratio)")
        if infos.count <= visibleCount {
            print("😆")
//            for (index, info) in self.infos.enumerated() {
//                if index == 0 {
//                    continue
//                }
//                let willInfo = self.infos[index - 1]
//
//                let currentTransform = info.transform
//                let willTransform = willInfo.transform
//
//                let currentFrame = info.frame
//                let willFrame = willInfo.frame
//
//                info.card.transform = CGAffineTransform(scaleX:currentTransform.a - (currentTransform.a - willTransform.a) * ratio,
//                                                        y: currentTransform.d - (currentTransform.d - willTransform.d) * ratio)
//
//
//                var frame = info.card.frame
//                frame.origin.y = currentFrame.origin.y - (currentFrame.origin.y - willFrame.origin.y) * ratio;
//                info.card.frame = frame
//            }
        } else {
            print("😝")
            for (index, info) in self.infos.enumerated() {
                print("\(info.position)")
                
                if index == self.infos.count - 1 || index == 0 {
                    continue
                }
                let willInfo = self.infos[index - 1]
                
                let currentTransform = info.transform
                let willTransform = willInfo.card.transform
                
                let currentPosition = info.position
                let willPosition = willInfo.position
                
                //info.card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                
                var position = info.card.layer.position
                position.y = currentPosition.y - (currentPosition.y - willPosition.y) * ratio;
                info.card.layer.position = position
                
                info.card.transform = CGAffineTransform(scaleX:currentTransform.a - (currentTransform.a - willTransform.a) * ratio,
                                                        y: currentTransform.d - (currentTransform.d - willTransform.d) * ratio)
                
                
                
                
                
                
            }
            print("=============")
        }
    }
    
    
    
    func disappear() {
//        let animation = { [weak self] in
//            guard let _self = self else {
//                return
//            }
//            // 1、infos数量小于等于visibleCount
//            // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
//            if _self.infos.count <= _self.visibleCount {
//                for (index, info) in _self.infos.enumerated() {
//                    if index == 0 {
//                        continue
//                    }
//                    let willInfo = _self.infos[index - 1]
//
//                    let willTransform = willInfo.transform
//                    let willFrame = willInfo.frame
//
//                    info.card.transform = willTransform
//
//                    var frame = info.card.frame
//                    frame.origin.y = willFrame.origin.y
//                    info.card.frame = frame
//                }
//            } else {
//                for (index, info) in _self.infos.enumerated() {
//                    if index == _self.infos.count - 1 || index == 0 {
//                        continue
//                    }
//                    let willInfo = _self.infos[index - 1]
//
//                    let willTransform = willInfo.transform
//                    let willFrame = willInfo.frame
//
//                    info.card.transform = willTransform
//
//                    var frame = info.card.frame
//                    frame.origin.y = willFrame.origin.y
//                    info.card.frame = frame
//                }
//            }
//        }
//        UIView.animate(withDuration: 0.3,
//                       delay: 0,
//                       usingSpringWithDamping: 0.3,
//                       initialSpringVelocity: 0.3,
//                       options: .curveEaseInOut,
//                       animations: {
//            animation()
//        }) { [weak self] (isFinish) in
//            guard let _self = self else {
//                return
//            }
//            if isFinish {
//                // 顶部的卡片移出去
//                if let info = _self.infos.first {
//                    info.card.removeFromSuperview()
//                    _self.infos.removeFirst()
//                }
//            }
//        }
    }
    
    func restore() {
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 0.8,
//                       options: .curveEaseInOut,
//                       animations: {
//                        for (_, info) in self.infos.enumerated() {
//                            info.card.transform = info.transform
//                            info.card.frame = info.frame
//                        }
//        }) { (isFinish) in
//            if isFinish {
//                // 只有当infos数量大于visibleCount时，才移除最底部的卡片
//                if self.infos.count > self.visibleCount {
//                    if let info = self.infos.last {
//                        info.card.removeFromSuperview()
//                    }
//                }
//                self.infos.removeLast()
//            }
//        }
    }
    
    
}


