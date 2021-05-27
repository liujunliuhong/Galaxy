//
//  Timer+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/27.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

private var targetKey = "targetKey"

fileprivate class Target: NSObject {
    @objc fileprivate func timerAction(timer: Timer){
        timer.timerBlock?()
    }
}

extension GL where Base == Timer {
    /// 传统`Timer`，不会导致循环引用
    public static func timer(timeInterval: TimeInterval, target: Any?, selector: Selector?, userInfo: Any, repeats: Bool) -> Timer? {
        guard let target = target else { return nil }
        guard let selector = selector else { return nil }
        let proxy = GLWeakProxy(target: target)
        return Timer(timeInterval: timeInterval, target: proxy, selector: selector, userInfo: userInfo, repeats: repeats)
    }
    
    /// 新版`Timer`，直接接受回调
    public static func timer(timeInterval: TimeInterval, repeats: Bool, block: (() -> Void)?) -> Timer {
        if #available(iOS 10.0, *) {
            let timer = Timer(timeInterval: timeInterval, repeats: repeats) { (timer) in
                block?()
            }
            return timer
        } else {
            let target = Target()
            let timer = Timer(timeInterval: timeInterval, target: target, selector: #selector(Target.timerAction(timer:)), userInfo: nil, repeats: repeats)
            timer.timerBlock = block
            return timer
        }
    }
}

extension Timer {
    fileprivate var timerBlock:(() -> Void)?{
        set{
            objc_setAssociatedObject(self, &targetKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            if let block = objc_getAssociatedObject(self, &targetKey) as? (() -> Void) {
                return block
            }
            return nil
        }
    }
}
