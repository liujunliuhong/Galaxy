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
    
    /// 卡片总数
    /// - Parameter dragCard: 容器
    func numberOfCount(_ dragCard: YHDragCard) -> Int
    
    /// 每个索引对应的卡片
    /// - Parameter dragCard: 容器
    /// - Parameter indexOfCard: 索引
    func dragCard(_ dragCard: YHDragCard, indexOfCard: Int) -> UIView
}

/// 代理
protocol YHDragCardDelegate: NSObjectProtocol {
    
    /// 显示顶层卡片的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 卡片
    /// - Parameter index: 索引
    func dragCard(_ dragCard: YHDragCard, didDisplayCard card: UIView, withIndexAt index: Int)
    
    /// 点击顶层卡片的回调
    /// - Parameter dragCard: 容器
    /// - Parameter index: 点击的顶层卡片的索引
    /// - Parameter card: 点击的定测卡片
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with card: UIView)
    
    /// 最后一个卡片滑完的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 最后一张卡片
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCard card: UIView)
    
    /// 顶层卡片滑出去的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 滑出去的卡片
    /// - Parameter index: 滑出去的卡片的索引
    /// 当最后一个卡片滑出去时，会和`didFinishRemoveLastCard`代理同时回调
    func dragCard(_ dragCard: YHDragCard, didRemoveCard card:UIView, withIndex index: Int)
    
    /// 当前卡片的滑动位置信息的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 顶层滑动的卡片
    /// - Parameter index: 卡片索引
    /// - Parameter direction: 卡片方向信息
    /// - Parameter canRemove: 卡片所处的位置是否可以移除
    /// 该代理可以用来干什么:
    /// 1.实现在滑动过程中，控制容器外部某个控件的形变、颜色、透明度等等
    /// 2、实现在滑动过程中，控制卡片内部某个按钮的形变、颜色、透明度等等(比如：右滑，like按钮逐渐显示；左滑，unlike按钮逐渐显示)
    func dragCard(_ dragCard: YHDragCard, currentCard card: UIView, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool)
}

extension YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCard card: UIView, withIndexAt index: Int) {}
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with card: UIView) {}
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCard card: UIView) {}
    func dragCard(_ dragCard: YHDragCard, didRemoveCard card:UIView, withIndex index: Int) {}
    func dragCard(_ dragCard: YHDragCard, currentCard card: UIView, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool) {}
}

/// 卡片的滑动信息
struct YHDragCardDirection {
    /// 卡片方向
    enum Direction {
        case `default`   // default
        case left        // 向左
        case right       // 向右
        case up          // 向上
        case down        // 向下
    }
    
    var horizontal: YHDragCardDirection.Direction = .default
    var vertical: YHDragCardDirection.Direction = .default
    var horizontalRatio: CGFloat = 0.0
    var verticalRatio: CGFloat = 0.0
}

/// 存储卡片的位置信息
class YHDragCardInfo: NSObject {
    let card: UIView
    var transform: CGAffineTransform
    var frame: CGRect
    init(card: UIView, transform: CGAffineTransform, frame: CGRect) {
        self.card = card
        self.transform = transform
        self.frame = frame
        super.init()
    }
}

extension YHDragCardInfo {
    override var description: String {
        return getInfo()
    }

    override var debugDescription: String {
        return getInfo()
    }

    func getInfo() -> String {
        return "[Card] \(card)\n[Transform] \(transform)\n[Frame] \(frame)"
    }
}


enum YHDragCardRemoveDirection {
    case horizontal
    case vertical
}


class YHDragCard: UIView {
    
    /// 数据源
<<<<<<< HEAD
    weak var dataSource: YHDragCardDataSource?
    
    /// 协议
    weak var delegate: YHDragCardDelegate?
=======
    public weak var dataSource: YHDragCardDataSource?
    
    /// 协议
    public weak var delegate: YHDragCardDelegate?
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027

    /// 可见卡片数量，默认3
    /// 取值范围:大于0
    /// 内部会根据`visibleCount`和`numberOfCount(_ dragCard: YHDragCard)`来纠正初始显示的卡片数量
    public var visibleCount: Int = 3
    
    /// 卡片之间的间隙，默认10.0
    /// 如果小于0.0，默认0.0
    /// 如果大于容器高度的一半，默认为容器高度一半
    public var cardSpacing: CGFloat = 10.0
    
    /// 最底部那张卡片的缩放比例，默认0.8
    /// 其余卡片的缩放比例会进行自动计算
    /// 取值范围:0.1 - 1.0
    /// 如果小于0.1，默认0.1
    /// 如果大于1.0，默认1.0
    public var minScale: CGFloat = 0.8
    
    /// 移除方向(一般情况下是水平方向移除的，但是有些设计是垂直方向移除的)
    /// 默认水平方向
    public var removeDirection: YHDragCardRemoveDirection = .horizontal
    
    /// 水平方向上最大移除距离，默认屏幕宽度1/4
    /// 取值范围:大于10.0
    /// 如果小于10.0，默认10.0
    /// 如果水平方向上能够移除卡片，请设置该属性的值
    public var horizontalRemoveDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0
    
    /// 水平方向上最大移除速度，默认1000.0
    /// 取值范围:大于100.0。如果小于100.0，默认100.0
    /// 如果水平方向上能够移除卡片，请设置该属性的值
    public var horizontalRemoveVelocity: CGFloat = 1000.0
    
    /// 垂直方向上最大移除距离，默认屏幕高度1/4
    /// 取值范围:大于50.0
    /// 如果小于50.0，默认50.0
    /// 如果垂直方向上能够移除卡片，请设置该属性的值
    public var verticalRemoveDistance: CGFloat = UIScreen.main.bounds.size.height / 4.0
    
    /// 垂直方向上最大移除速度，默认1000.0
    /// 取值范围:大于100.0。如果小于100.0，默认100.0
    /// 如果垂直方向上能够移除卡片，请设置该属性的值
    public var verticalRemoveVelocity: CGFloat = 500.0
    
    /// 侧滑角度，默认10.0度(最大会旋转10.0度)
    /// 取值范围:0.0 - 90.0
    /// 如果小于0.0，默认0.0
    /// 如果大于90.0，默认90.0
    /// 当`removeDirection`设置为`vertical`时，会忽略该属性
    /// 在滑动过程中会根据`horizontalRemoveDistance`和`removeMaxAngle`来动态计算卡片的旋转角度
    /// 目前我还没有遇到过在垂直方向上能移除卡片的App，因此如果上下滑动，卡片的旋转效果很小，只有在水平方向上滑动，才能观察到很明显的旋转效果
    /// 因为我也不知道当垂直方向上滑动时，怎么设置卡片的旋转效果🤣
    public var removeMaxAngle: CGFloat = 10.0
    
    /// 卡片滑动方向和纵轴之间的角度，默认5.0
    /// 取值范围:5.0 - 85.0
    /// 如果小于5.0，默认5.0
    /// 如果大于85.0，默认85.0
    /// 如果水平方向滑动能移除卡片，请把该值设置的尽量小
    /// 如果垂直方向能够移除卡片，请把该值设置的大点
    public var demarcationAngle: CGFloat = 5.0
    
    
    
    
    
    
    
    
    /// 当前索引
    /// 顶层卡片的索引(直接与用户发生交互)
    private var currentIndex: Int = 0
    
    /// 初始顶层卡片的位置
    private var initialFirstCardCenter: CGPoint = .zero
    
    /// 存储的卡片信息
    private var infos: [YHDragCardInfo] = [YHDragCardInfo]()
    
    
    /// 目前暂时只支持纯frame的方式初始化
    /// - Parameter frame: frame
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
        reloadData(animation: false)
    }
    
}

extension YHDragCard {
    public func reloadData(animation: Bool) {
        self.infos.forEach { (transform) in
            transform.card.removeFromSuperview()
        }
        self.infos.removeAll()
        self.currentIndex = 0
        
        // 纠正
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        
        if showCount <= 0 { return }
        
        var scale: CGFloat = 1.0
        if showCount > 1 {
            scale = CGFloat(1.0 - correctScale()) / CGFloat(showCount - 1)
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
                
                if animation {
                    UIView.animate(withDuration: 0.25, animations: {
                        _card.transform = transform
                    }, completion: nil)
                } else {
                    _card.transform = transform
                }
                
                let info = YHDragCardInfo(card: _card, transform: _card.transform, frame: _card.frame)
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
        
        // 显示顶层卡片的回调
        if let _topCard = self.infos.first?.card {
            self.delegate?.dragCard(self, didDisplayCard: _topCard, withIndexAt: self.currentIndex)
        }
    }
    
    
<<<<<<< HEAD
    
    func installNextCard() {
=======
    func nextCard() {
        
    }
    
    
    
}


extension YHDragCard {
    private func installNextCard() {
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)

        // 判断
        if self.currentIndex + showCount >= maxCount { return }
        
        if showCount <= 0 { return }
        
        let card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex + 1)
        
        guard let _card = card else { return }
        guard let bottomCard = infos.last?.card else { return }
        
        _card.isUserInteractionEnabled = false
        _card.backgroundColor = UIColor.YH_RandomColor
        _card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        insertSubview(_card, at: 0)

        _card.transform = .identity
        _card.transform = bottomCard.transform
        _card.frame = bottomCard.frame

        let info = YHDragCardInfo(card: _card, transform: _card.transform, frame: _card.frame)
        self.infos.append(info)

        addPanGesture(for: _card)
    }
    
    
    /// 给卡片添加pan手势
    /// - Parameter card: 卡片
    private func addPanGesture(for card: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        card.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
        card.addGestureRecognizer(tap)
    }
}

<<<<<<< HEAD

=======
extension YHDragCard {
    /// 纠正minScale   [0.1, 1.0]
    private func correctScale() -> CGFloat {
        var scale = self.minScale
        if scale > 1.0 {
            scale = 1.0
        }
        if scale <= 0.1 {
            scale = 0.1
        }
        return scale
    }
    
    /// 纠正cardSpacing  [0.0, bounds.size.height / 2.0]
    func correctCardSpacing() -> CGFloat {
        var spacing: CGFloat = 0.0
        if cardSpacing < 0.0 {
            spacing = 0.0
        } else if cardSpacing > bounds.size.height / 2.0 {
            spacing = bounds.size.height / 2.0
        }
        return spacing
    }
    
    /// 纠正侧滑角度，并把侧滑角度转换为弧度  [0.0, 90.0]
    private func correctRemoveMaxAngleAndToRadius() -> CGFloat {
        var angle: CGFloat = removeMaxAngle
        if angle < 0.0 {
            angle = 0.0
        } else if angle > 90.0 {
            angle = 90.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
    
    /// 纠正水平方向上的最大移除距离，内部做了判断 [10.0, ∞)
    private func correctHorizontalRemoveDistance() -> CGFloat {
        return horizontalRemoveDistance < 10.0 ? 10.0 : horizontalRemoveDistance
    }
    
    /// 纠正水平方向上的最大移除速度  [100.0, ∞)
    func correctHorizontalRemoveVelocity() -> CGFloat {
        return horizontalRemoveVelocity < 100.0 ? 100.0 : horizontalRemoveVelocity
    }
    
    /// 纠正垂直方向上的最大移距离  [50.0, ∞)
    func correctVerticalRemoveDistance() -> CGFloat {
        return verticalRemoveDistance < 50.0 ? 50.0 : verticalRemoveDistance
    }
    
    /// 纠正垂直方向上的最大移除速度  [100.0, ∞)
    func correctVerticalRemoveVelocity() -> CGFloat {
        return verticalRemoveVelocity < 100.0 ? 100.0 : verticalRemoveVelocity
    }
    
    /// 纠正卡片滑动方向和纵轴之间的角度，并且转换为弧度   [5.0, 85.0]
    func correctDemarcationAngle() -> CGFloat {
        var angle = demarcationAngle
        if demarcationAngle < 5.0 {
            angle = 5.0
        } else if demarcationAngle > 85.0 {
            angle = 85.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
}
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027


extension YHDragCard {
    
    /// tap手势
    /// - Parameter tapGesture: gesture
    @objc private func tapGestureRecognizer(tapGesture: UITapGestureRecognizer) {
        guard let _card = self.infos.first?.card else { return }
        self.delegate?.dragCard(self, didSelectIndexAt: self.currentIndex, with: _card)
    }
    
    
    /// pan手势
    /// - Parameter panGesture: gesture
    @objc private func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
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
            
            // 垂直方向上的滑动比例
            let verticalMoveDistance: CGFloat = cardView.center.y - initialFirstCardCenter.y
            var verticalRatio = verticalMoveDistance / correctVerticalRemoveDistance()
            if verticalRatio < -1.0 {
                verticalRatio = -1.0
            } else if verticalRatio > 1.0 {
                verticalRatio = 1.0
            }
            
            // 水平方向上的滑动比例
            let horizontalMoveDistance: CGFloat = cardView.center.x - initialFirstCardCenter.x
            var horizontalRatio = horizontalMoveDistance / correctHorizontalRemoveDistance()
            
            if horizontalRatio < -1.0 {
                horizontalRatio = -1.0
            } else if horizontalRatio > 1.0 {
                horizontalRatio = 1.0
            }
            
            // 设置手指拖住的那张卡牌的旋转角度
            let rotationAngle = horizontalRatio * correctRemoveMaxAngleAndToRadius()
            
            cardView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            // 复位
            panGesture.setTranslation(.zero, in: self)
            // 卡牌变化
            moving(ratio: abs(horizontalRatio))
            
            // 滑动过程中的方向设置
            var horizontal: YHDragCardDirection.Direction = .default
            var vertical: YHDragCardDirection.Direction = .default
            if horizontalRatio > 0.0 {
                horizontal = .right
            } else if horizontalRatio < 0.0 {
                horizontal = .left
            }
            if verticalRatio > 0.0 {
                vertical = .down
            } else if verticalRatio < 0.0 {
                vertical = .up
            }
            // 滑动过程中的回调
            let direction = YHDragCardDirection(horizontal: horizontal, vertical: vertical, horizontalRatio: horizontalRatio, verticalRatio: verticalRatio)
            self.delegate?.dragCard(self, currentCard: cardView, withIndex: self.currentIndex, currentCardDirection: direction, canRemove: false)
            
        case .ended:
            print("ended")
            let horizontalMoveDistance: CGFloat = cardView.center.x - initialFirstCardCenter.x
            let verticalMoveDistance: CGFloat = cardView.center.y - initialFirstCardCenter.y
            if removeDirection == .horizontal {
                if (abs(horizontalMoveDistance) > horizontalRemoveDistance || abs(velocity.x) > horizontalRemoveVelocity) &&
                    abs(verticalMoveDistance) > 10.0 && // 避免分母为0
                    abs(horizontalMoveDistance) / abs(verticalMoveDistance) >= tan(correctDemarcationAngle()){
                    disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, completion: nil)
                } else {
                    restore()
                }
            } else {
                if (abs(verticalMoveDistance) > horizontalRemoveDistance || abs(velocity.y) > verticalRemoveVelocity) &&
                    abs(verticalMoveDistance) > 10.0 && // 避免分母为0
                    abs(horizontalMoveDistance) / abs(verticalMoveDistance) <= tan(correctDemarcationAngle()) {
                    disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, completion: nil)
                } else {
                    restore()
                }
            }
        case .cancelled, .failed:
            print("cancelled or failed")
            restore()
        default:
            break
        }
    }
}

<<<<<<< HEAD
extension YHDragCard {
    /// 纠正minScale   [0.1, 1.0]
    private func correctScale() -> CGFloat {
        var scale = self.minScale
        if scale > 1.0 {
            scale = 1.0
        }
        if scale <= 0.1 {
            scale = 0.1
        }
        return scale
    }
    
    /// 纠正cardSpacing  [0.0, bounds.size.height / 2.0]
    func correctCardSpacing() -> CGFloat {
        var spacing: CGFloat = 0.0
        if cardSpacing < 0.0 {
            spacing = 0.0
        } else if cardSpacing > bounds.size.height / 2.0 {
            spacing = bounds.size.height / 2.0
        }
        return spacing
    }
    
    /// 纠正侧滑角度，并把侧滑角度转换为弧度  [0.0, 90.0]
    private func correctRemoveMaxAngleAndToRadius() -> CGFloat {
        var angle: CGFloat = removeMaxAngle
        if angle < 0.0 {
            angle = 0.0
        } else if angle > 90.0 {
            angle = 90.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
    
    /// 纠正水平方向上的最大移除距离，内部做了判断 [10.0, ∞)
    private func correctHorizontalRemoveDistance() -> CGFloat {
        return horizontalRemoveDistance < 10.0 ? 10.0 : horizontalRemoveDistance
    }
    
    /// 纠正水平方向上的最大移除速度  [100.0, ∞)
    func correctHorizontalRemoveVelocity() -> CGFloat {
        return horizontalRemoveVelocity < 100.0 ? 100.0 : horizontalRemoveVelocity
    }
    
    /// 纠正垂直方向上的最大移距离  [50.0, ∞)
    func correctVerticalRemoveDistance() -> CGFloat {
        return verticalRemoveDistance < 50.0 ? 50.0 : verticalRemoveDistance
    }
    
    /// 纠正垂直方向上的最大移除速度  [100.0, ∞)
    func correctVerticalRemoveVelocity() -> CGFloat {
        return verticalRemoveVelocity < 100.0 ? 100.0 : verticalRemoveVelocity
    }
    
    /// 纠正卡片滑动方向和纵轴之间的角度，并且转换为弧度   [5.0, 85.0]
    func correctDemarcationAngle() -> CGFloat {
        var angle = demarcationAngle
        if demarcationAngle < 5.0 {
            angle = 5.0
        } else if demarcationAngle > 85.0 {
            angle = 85.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
}

extension YHDragCard {
    func moving(ratio: CGFloat) {
=======

extension YHDragCard {
    private func moving(ratio: CGFloat) {
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027
        // 1、infos数量小于等于visibleCount
        // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
        var ratio = ratio
        if ratio < 0.0 {
            ratio = 0.0
        } else if ratio > 1.0 {
            ratio = 1.0
        }
        
        for (index, info) in self.infos.enumerated() {
            if self.infos.count <= self.visibleCount {
                if index == 0 { continue }
            } else {
                if index == self.infos.count - 1 || index == 0 { continue }
            }
            let willInfo = self.infos[index - 1]
            
            let currentTransform = info.transform
            let willTransform = willInfo.transform
            
            let currentFrame = info.frame
            let willFrame = willInfo.frame
            
            info.card.transform = CGAffineTransform(scaleX:currentTransform.a - (currentTransform.a - willTransform.a) * ratio,
                                                    y: currentTransform.d - (currentTransform.d - willTransform.d) * ratio)
            var frame = info.card.frame
            frame.origin.y = currentFrame.origin.y - (currentFrame.origin.y - willFrame.origin.y) * ratio;
            info.card.frame = frame
        }
    }
    
    
    
<<<<<<< HEAD
    func disappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, completion closure: (()->())?) {
=======
    private func disappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, completion closure: (()->())?) {
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027
        let animation = { [weak self] in
            guard let _self = self else { return }
            // 顶层卡片位置设置
            if let _topCard = _self.infos.first?.card {
                if _self.removeDirection == .horizontal {
                    var flag: Int = 0
                    if horizontalMoveDistance > 0 {
                        flag = 2 // 右边滑出
                    } else {
                        flag = -1 // 左边滑出
                    }
                    let tmpWidth = UIScreen.main.bounds.size.width * CGFloat(flag)
                    let tmpHeight = verticalMoveDistance / horizontalMoveDistance * tmpWidth
                    _topCard.center = CGPoint(x: tmpWidth, y: tmpHeight)
                } else {
                    var flag: Int = 0
                    if verticalMoveDistance > 0 {
                        flag = 2 // 向下滑出
                    } else {
                        flag = -1 // 向上滑出
                    }
                    let tmpHeight = UIScreen.main.bounds.size.height * CGFloat(flag)
                    let tmpWidth = horizontalMoveDistance / verticalMoveDistance * tmpHeight
                    _topCard.center = CGPoint(x: tmpWidth, y: tmpHeight)
                }
            }
            // 1、infos数量小于等于visibleCount，表明不会再增加新卡片了
            // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
            for (index, info) in _self.infos.enumerated() {
                if _self.infos.count <= _self.visibleCount {
                    if index == 0 { continue }
                } else {
                    if index == _self.infos.count - 1 || index == 0 { continue }
                }
                let willInfo = _self.infos[index - 1]
                
                info.card.transform = willInfo.transform
                
                var frame = info.card.frame
                frame.origin.y = willInfo.frame.origin.y
                info.card.frame = frame
            }
            
            if let _topCard = _self.infos.first?.card {
                // 垂直方向上的滑动比例
                let verticalMoveDistance: CGFloat = _topCard.center.y - _self.initialFirstCardCenter.y
                var verticalRatio = verticalMoveDistance / _self.correctVerticalRemoveDistance()
                if verticalRatio < -1.0 {
                    verticalRatio = -1.0
                } else if verticalRatio > 1.0 {
                    verticalRatio = 1.0
                }
                
                // 水平方向上的滑动比例
                let horizontalMoveDistance: CGFloat = _topCard.center.x - _self.initialFirstCardCenter.x
                var horizontalRatio = horizontalMoveDistance / _self.correctHorizontalRemoveDistance()
                if horizontalRatio < -1.0 {
                    horizontalRatio = -1.0
                } else if horizontalRatio > 1.0 {
                    horizontalRatio = 1.0
                }
                
                var horizontal: YHDragCardDirection.Direction = .default
                var vertical: YHDragCardDirection.Direction = .default
                if horizontalRatio > 0.0 {
                    horizontal = .right
                } else if horizontalRatio < 0.0 {
                    horizontal = .left
                }
                if verticalRatio > 0.0 {
                    vertical = .down
                } else if verticalRatio < 0.0 {
                    vertical = .up
                }
                
                let direction = YHDragCardDirection(horizontal: horizontal, vertical: vertical, horizontalRatio: horizontalRatio, verticalRatio: verticalRatio)
                _self.delegate?.dragCard(_self, currentCard: _topCard, withIndex: _self.currentIndex, currentCardDirection: direction, canRemove: true)
            }
        }
        UIView.animate(withDuration: 0.5,
                       animations: {
            animation()
        }) { [weak self] (isFinish) in
            guard let _self = self else { return }
            if isFinish {
                // 交换每个info的位置信息
                for (index, info) in _self.infos.enumerated().reversed() { // 倒叙交换位置
                    if _self.infos.count <= _self.visibleCount {
                        if index == 0 { continue }
                    } else {
                        if index == _self.infos.count - 1 || index == 0 { continue }
                    }
                    let willInfo = _self.infos[index - 1]
                    
                    let willTransform = willInfo.transform
                    let willFrame = willInfo.frame
                    
                    info.transform = willTransform
                    info.frame = willFrame
                }
                
                guard let info = _self.infos.first else { return }
                
                info.card.removeFromSuperview()
                _self.infos.removeFirst()
                
                // 卡片滑出去的回调
                _self.delegate?.dragCard(_self, didRemoveCard: info.card, withIndex: _self.currentIndex)
                
                // 这儿再回调一次，相当于复位
                let direction = YHDragCardDirection(horizontal: .default, vertical: .default, horizontalRatio: 0.0, verticalRatio: 0.0)
                _self.delegate?.dragCard(_self, currentCard: info.card, withIndex: _self.currentIndex, currentCardDirection: direction, canRemove: true)
                
                // 顶部的卡片Remove
                if _self.currentIndex == (_self.dataSource?.numberOfCount(_self) ?? 0) - 1 {
                    // 卡片只有最后一张了，此时闭包不回调出去
                    // 最后一张卡片移除出去的回调
                    _self.delegate?.dragCard(_self, didFinishRemoveLastCard: info.card)
                } else {
                    // 如果不是最后一张卡片移出去，则把索引+1
                    _self.currentIndex = _self.currentIndex + 1
                    _self.infos.first?.card.isUserInteractionEnabled = true
                    
                    // 显示当前卡片的回调
                    if let _tmpTopCard = _self.infos.first?.card {
                        _self.delegate?.dragCard(_self, didDisplayCard: _tmpTopCard, withIndexAt: _self.currentIndex)
                    }
                    closure?() // 闭包回调
                }
            }
        }
    }
    
<<<<<<< HEAD
    
=======
>>>>>>> 345d08be6996644e38870a428cc648b9b33dc027
    /// 重置所有卡片位置信息
    private func restore() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        guard let _self = self else { return }
                        for (_, info) in _self.infos.enumerated() {
                            info.card.transform = info.transform
                            info.card.frame = info.frame
                        }
                        // 复位时，滑动过程中的回调
                        if let _topCard = _self.infos.first?.card {
                            let direction = YHDragCardDirection(horizontal: .default, vertical: .default, horizontalRatio: 0.0, verticalRatio: 0.0)
                            _self.delegate?.dragCard(_self, currentCard: _topCard, withIndex: _self.currentIndex, currentCardDirection: direction, canRemove: false)
                        }
        }) { [weak self] (isFinish) in
            guard let _self = self else { return }
            if isFinish {
                // 只有当infos数量大于visibleCount时，才移除最底部的卡片
                if _self.infos.count > _self.visibleCount {
                    if let info = _self.infos.last {
                        info.card.removeFromSuperview()
                    }
                    _self.infos.removeLast()
                }
            }
        }
    }
}


