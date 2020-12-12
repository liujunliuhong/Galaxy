//
//  GLDatingAutoAction.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

internal class GLDatingAutoAction: NSObject {
    /// 当前索引，表示在第几个时间间隔
    private var currentIndex: Int = 0
    /// 定时器集合
    private var timers: [Timer] = []
    
    
    /// 时间间隔集合
    private let timeIntervals: [TimeInterval]
    /// 定时器回调
    private let closure: (() -> Void)?
    
    
    internal init(timeIntervals: [TimeInterval], closure: (() -> Void)?) {
        self.timeIntervals = timeIntervals
        self.closure = closure
        super.init()
    }
}

extension GLDatingAutoAction {
    /// 停止执行自动事件
    internal func stopAutoAction() {
        self.removeAllTimers()
    }
    
    /// 开始执行自动事件
    internal func startAutoAction() {
        if self.timeIntervals.count <= 0 {
            GLDatingLog("[执行自动事件] 时间间隔集合为空，不能执行自动事件")
            return
        }
        func start(timeInterval: TimeInterval) {
            let timer = Timer(timeInterval: timeInterval,
                              target: GLWeakProxy(target: self),
                              selector: #selector(timerAction(timer:)),
                              userInfo: nil,
                              repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            self.timers.append(timer)
        }
        if self.currentIndex <= self.timeIntervals.count - 1 {
            let timeInterval = self.timeIntervals[self.currentIndex]
            start(timeInterval: timeInterval)
        } else {
            let timeInterval = self.timeIntervals.last!
            start(timeInterval: timeInterval)
        }
    }
}

extension GLDatingAutoAction {
    /// 定时器事件
    @objc private func timerAction(timer: Timer) {
        //
        GLDatingLog("[收到自动事件执行成功的回调]")
        // 索引+1
        self.currentIndex += 1
        // remove
        self.removeCurrentTimer(timer: timer)
        // 执行回调
        self.closure?()
        // 开始执行下一个时间
        self.startAutoAction()
    }
}


extension GLDatingAutoAction {
    
    /// 移除某个timer
    private func removeCurrentTimer(timer: Timer) {
        timer.invalidate()
        for (index, t) in self.timers.enumerated() {
            if t == timer {
                self.timers.remove(at: index)
                break
            }
        }
    }
    
    /// 移除所有timer
    private func removeAllTimers() {
        for (_, t) in self.timers.enumerated() {
            t.invalidate()
        }
        self.timers.removeAll()
    }
}
