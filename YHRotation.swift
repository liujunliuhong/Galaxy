//
//  YHRotation.swift
//  SwiftTool
//
//  Created by apple on 2019/6/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit


/************************************************************************************
 ************************************************************************************
 
 针对屏幕旋转做的配置，使用的时候，只需要在对应的ViewController写相应的方法就可以了
 
 ************************************************************************************
 ************************************************************************************/







/*
 1、A页面初始竖屏，点击某个按钮之后，强制横屏：
 shouldAutorotate                                true
 preferredInterfaceOrientationForPresentation    portrait
 supportedInterfaceOrientations                  点击按钮之前，设置为portrait，点击按钮之后，设置为landscapeRight。可以用一个全局变量来保存此状态
                                                 同时点击按钮时，调用YH_ForcedToRotation方法
 
 
 2、A页面竖屏，进入B页面就横屏，且不管怎么旋转手机，屏幕旋转方向都不变，则B页面的设置：
 shouldAutorotate                                false
 preferredInterfaceOrientationForPresentation    landscapeRight
 supportedInterfaceOrientations                  landscapeRight
 preferredInterfaceOrientationForPresentation和supportedInterfaceOrientations的方向要一致
 
 
 
 3、页面可以来回旋转
 shouldAutorotate                                true
 其余的属性都可以不用设置
 
 */









// 如果A跳转到B，B返回到A，A的界面出现了旋转，请在ViewWillAppear方法里面加入YH_CorrectRatation
// 同时在A的preferredInterfaceOrientationForPresentation方法里面赋值YHInitialRotaion
extension UIViewController {
    private struct YHRotationAssociatedKeys {
        static var key = "com.yinhe.rotation.key"
    }
    
    // 记录页面的旋转方向
    var YHInitialRotaion: UIInterfaceOrientation {
        set {
            objc_setAssociatedObject(self, &YHRotationAssociatedKeys.key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return UIInterfaceOrientation(rawValue: (objc_getAssociatedObject(self, &YHRotationAssociatedKeys.key) as? Int) ?? 1) ?? .portrait
        }
    }
    
    // 纠正屏幕的旋转方法
    func YH_CorrectRatation() {
        self.YH_ForcedToRotation(self.YHInitialRotaion)
    }
    
    // 强制屏幕旋转到指定方向
    // supportedInterfaceOrientations也要跟着设置，可以用一个全局变量来保存此状态
    func YH_ForcedToRotation(_ rotation: UIInterfaceOrientation) {
        let unkown = NSNumber.init(value: UIInterfaceOrientation.unknown.rawValue)
        UIDevice.current.setValue(unkown, forKey: "orientation")
        let set = NSNumber.init(value: rotation.rawValue)
        UIDevice.current.setValue(set, forKey: "orientation")
    }
    
}


extension UINavigationController {
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

extension UITabBarController {
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController?.childForStatusBarStyle
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.selectedViewController?.childForStatusBarHidden
    }
    
    open override var shouldAutorotate: Bool{
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
