//
//  UIDevice+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base == UIDevice {
    /// 获取屏幕宽
    public static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 获取屏幕高
    public static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// 获取设备机器名字，例如`iPhone 7 Plus`.
    public static var machineName: String {
        let machine = UIDevice._machine
        var machineName = machine
        for (_, type) in GalaxyWrapper.DeviceType.allCases.enumerated() {
            if type.identifiers.contains(machine) {
                machineName = type.description
                break
            }
        }
        return machineName
    }
    
    /// 获取设备基本信息
    public static var deviceInformation: String {
        return
            "\n"
            +
            "*******************************************************************"
            + "\n"
            + "Sysname:          \(UIDevice._sysname)"
            + "\n"
            + "Release:          \(UIDevice._release)"
            + "\n"
            + "Version:          \(UIDevice._version)"
            + "\n"
            + "Machine:          \(UIDevice._machine)"
            + "\n"
            + "SystemVersion:    \(UIDevice.current.systemVersion)"
            + "\n"
            + "MachineName:      \(GL.machineName)"
            + "\n"
            + "DeviceName:       \(UIDevice.current.name)"
            + "\n"
            + "*******************************************************************"
    }
    
    /// 是否是模拟器
    public static var isSimulator: Bool {
        let machine = UIDevice._machine
        var isSimulator: Bool = false
        for (_, type) in GalaxyWrapper.DeviceType.allCases.enumerated() {
            if type == .simulator && type.identifiers.contains(machine) {
                isSimulator = true
                break
            }
        }
        return isSimulator
    }
    
    /// 是否是刘海屏手机，兼容真机和模拟器
    ///
    /// 模拟器通过判断`safeAreaInsets.bottom`是否大于`0`
    /// 真机通过判断机器型号
    public static var isNotchiPhone: Bool {
        var isNotchiPhone: Bool = false
        if GL.isSimulator {
            if #available(iOS 11.0, *) { // `safeAreaInsets`是在`iOS 11`开始提出的概念
                if let delegate = UIApplication.shared.delegate, let _window = delegate.window, let window = _window {
                    isNotchiPhone = window.safeAreaInsets.bottom > 0
                }
            }
        } else {
            let machine = UIDevice._machine
            for (_, type) in GalaxyWrapper.DeviceType.allCases.enumerated() {
                if (type == .iPhone_X || type == .iPhone_XR || type == .iPhone_XS || type == .iPhone_XS_Max ||
                        type == .iPhone_11 || type == .iPhone_11_Pro || type == .iPhone_11_Pro_Max ||
                        type == .iPhone_12 || type == .iPhone_12_Pro || type == .iPhone_12_mini || type == .iPhone_12_Pro_Max) &&
                    type.identifiers.contains(machine) {
                    isNotchiPhone = true
                    break
                }
            }
        }
        return isNotchiPhone
    }
    
    /// 获取状态栏高度
    public static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                statusBarHeight = statusBarManager.statusBarFrame.height
            }
        }
        return statusBarHeight
    }
    
    /// 是否隐藏了状态栏
    public static var isStatusBarHidden: Bool {
        var isStatusBarHidden: Bool = UIApplication.shared.isStatusBarHidden
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                isStatusBarHidden = statusBarManager.isStatusBarHidden
            }
        }
        return isStatusBarHidden
    }
    
    /// 获取状态栏样式
    public static var statusBarStyle: UIStatusBarStyle {
        var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate,
               let _window = delegate.window,
               let window = _window,
               let windowScene = window.windowScene,
               let statusBarManager = windowScene.statusBarManager {
                statusBarStyle = statusBarManager.statusBarStyle
            }
        }
        return statusBarStyle
    }
    
    /// 获取虚拟Home键高度，兼容真机和模拟器
    public static var homeIndicatorHeight: CGFloat {
        var homeIndicatorHeight: CGFloat = .zero
        if #available(iOS 11.0, *) {
            if let delegate = UIApplication.shared.delegate, let _window = delegate.window, let window = _window {
                homeIndicatorHeight = window.safeAreaInsets.bottom
            }
        }
        return homeIndicatorHeight
    }
}

extension UIDevice {
    fileprivate static var _sys: utsname {
        var sys: utsname = utsname()
        uname(&sys)
        return sys
    }
    
    fileprivate static var _machine: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _release: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _version: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _sysname: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
    fileprivate static var _nodename: String {
        var sys = UIDevice._sys
        return withUnsafePointer(to: &sys.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String(validatingUTF8: ptr) } ?? UIDevice.current.systemVersion
        }
    }
}
