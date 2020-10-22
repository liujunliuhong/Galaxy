//
//  ViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

fileprivate class Model: NSObject {
    
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo"
        self.view.backgroundColor = .white
        
//
//
//        let sort = SwiftyWordsSort<Model>()
//        let result = SwiftyWordsSort.getFirstEnglishWords(string: " ,.,;'!@#$%^&*() 嘻嘻哈哈啦啦abc ")
//        print("\(result)")
    }
}


extension ViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let vc = SwiftyBMKLocationTestViewController(bmk_key: bmk_key)
        //let vc = SwiftyNativeLocationTestViewController()
        //let vc = SwiftyAMapLocationTestViewController(amap_key: amap_key)
//        let vc = SwiftyQCloudCOSManagerTestViewController(appID: tencent_uplaod_appID, regionName: tencent_uplaod_regionName, secretID: tencent_uplaod_secretID, secretKey: tencent_uplaod_secretKey, bucketName: tencent_upload_bucketName)
        //let vc = SwiftyCusNavigationBarTestViewController(testImage: UIImage(named: "item_Image_1"))
        //self.navigationController?.pushViewController(vc, animated: true)
        
        
        //print("\(UIDevice.YH_Width)")
        
        
        
        
        /*
         let normalImages: [UIImage?] = [UIImage(named: "chats_normal"),
         UIImage(named: "photo_big"),
         UIImage(named: "discover_normal"),
         UIImage(named: "me_normal")]
         
         let selectImages: [UIImage?] = [UIImage(named: "chats_selected"),
         UIImage(named: "photo_big"),
         UIImage(named: "discover_selected"),
         UIImage(named: "me_selected")]
         let titles: [String] = ["聊天",
         "联系人",
         "发现",
         "我的"]
         
         let vc = SwiftyTabBarDemoProvider.demo(images: normalImages, selectImages: selectImages, titles: titles)
         self.navigationController?.pushViewController(vc, animated: true)
         */
        
        //let vc = SwiftyCusNavigationBarTestViewController(testImage: UIImage(named: "item_Image_1"))
        //self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = GLFlowItemsDemoViewController(type: .autoWidth)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}

