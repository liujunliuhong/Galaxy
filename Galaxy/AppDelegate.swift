//
//  AppDelegate.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/28.
//

import UIKit
import FLEX

private class _Navi: UINavigationController {
    override var childForStatusBarHidden: UIViewController? {
        return self.viewControllers.last
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.viewControllers.last?.prefersStatusBarHidden ?? false
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FLEXManager.shared.showExplorer()
        
        Log.setup(saveToSandbox: true)
        MyLog(GL.deviceInformation)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navi = _Navi(rootViewController: vc)
        self.window?.rootViewController = navi
        
        let size = 1024*1024+7100
        print(FileManager.default.gl.formatSize(length: size))
        
        return true
    }
}

