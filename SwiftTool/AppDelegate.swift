//
//  AppDelegate.swift
//  SwiftTool
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit
import GLDeviceTool
import FLEX


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FLEXManager.shared.showExplorer()
        
        GLLogSetup(saveToSandbox: true)
        GLLog(UIDevice.gl_info)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navi = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        
        let size = 1024*1024+7100
        print(FileManager.default.gl_formatSize(length: size))
        
        
        
        return true
    }
}

