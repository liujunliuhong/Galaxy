//
//  GLDatingAutoActionManager.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public class GLDatingAutoActionManager {
    public static let `default` = GLDatingAutoActionManager()
    
    private var autoActions: [String: GLDatingAutoAction] = [:]
    
    private init() {
        
    }
}

extension GLDatingAutoActionManager {
    /// 添加自动事件
    public func addAutoAction(label: String, timeIntervals: [TimeInterval], closure: (() -> Void)?) {
        guard label.count > 0 else {
            GLDatingLog("[添加自动事件] [`label`长度必须大于0]")
            return
        }
        guard timeIntervals.count > 0 else {
            GLDatingLog("[添加自动事件] [`timeIntervals`数目必须大于0]")
            return
        }
        for (_, autoAction) in self.autoActions.enumerated() {
            if autoAction.key == label {
                self.stopAutoAction(label: autoAction.key)
                break
            }
        }
        let autoAction = GLDatingAutoAction(timeIntervals: timeIntervals, closure: closure)
        self.autoActions[label] = autoAction
        autoAction.startAutoAction()
        GLDatingLog("[添加`label = \(label)`的自动事件成功]")
    }
    
    /// 停止某个自动事件
    public func stopAutoAction(label: String) {
        guard self.autoActions.keys.contains(label) else {
            GLDatingLog("[停止自动事件] [`label = \(label)`不存在]")
            return
        }
        for (_, autoAction) in self.autoActions.enumerated() {
            if autoAction.key == label {
                autoAction.value.stopAutoAction()
                self.autoActions.removeValue(forKey: autoAction.key)
                GLDatingLog("[停止`label = \(label)`的自动事件成功]")
                break
            }
        }
    }
    
    /// 停止所有自动事件
    public func stopAllAutoActions() {
        for (_, autoAction) in self.autoActions.enumerated() {
            GLDatingLog("[停止`label = \(autoAction.key)`的自动事件成功]")
            autoAction.value.stopAutoAction()
        }
        self.autoActions.removeAll()
    }
}
