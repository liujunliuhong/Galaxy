//
//  CALayer+Extension.swift
//  Galaxy
//
//  Created by liujun on 2021/7/9.
//

import Foundation
import QuartzCore
import UIKit


extension GL where Base == CALayer {
    /// 暂停动画
    public func pauseAnimation() {
        //取出当前时间,转成动画暂停的时间
        let pausedTime = base.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        base.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        base.timeOffset = pausedTime
    }
    
    /// 恢复动画
    public func resumeAnimation() {
        //获取暂停的时间差
        let pausedTime = base.timeOffset
        base.speed = 1.0
        base.timeOffset = 0.0
        base.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = base.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        base.beginTime = timeSincePause
    }
}
