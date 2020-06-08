//
//  SwiftyQCloudCOSManagerTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import QCloudCore
import QCloudCOSXML

public class SwiftyQCloudCOSManagerTestViewController: UIViewController {

    deinit {
        print("\(self.classForCoder) deinit")
    }
    
    private let appID: String
    private let regionName: String
    private let secretID: String
    private let secretKey: String
    private let bucketName: String
    
    public init(appID: String, regionName: String, secretID: String, secretKey: String, bucketName: String) {
        self.appID = appID
        self.regionName = regionName
        self.secretID = secretID
        self.secretKey = secretKey
        self.bucketName = bucketName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var uploadButton: UIButton = {
        let uploadButton = UIButton(type: .system)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = .gray
        uploadButton.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
        return uploadButton
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        let leftMargin: CGFloat = 20.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.uploadButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.view.addSubview(self.uploadButton)
        
        // 1
        SwiftyQCloudCOSManager.default.setup { [weak self] (configuration) in
            guard let self = self else { return }
            //
            configuration.appID = self.appID
            //
            let endpoint = QCloudCOSXMLEndPoint.init()
            endpoint.regionName = self.regionName
            endpoint.useHTTPS = true
            configuration.endpoint = endpoint
        }
        
        // 2
        SwiftyQCloudCOSManager.default.update(authentationType: .forever(secretID: self.secretID, secretKey: self.secretKey))
    }
}


extension SwiftyQCloudCOSManagerTestViewController {
    @objc func uploadAction() {
        guard let path = Bundle.main.path(forResource: "test", ofType: "png") else { return }
        
        let d = DateFormatter()
        d.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        var key = d.string(from: Date())
        key = "aa/" + key + ".png"
        
        SwiftyQCloudCOSManager.default.upload(path: path, bucketName: self.bucketName, key: key, configuration: { (uploadRequest) in
            
        }, progressClosure: { (progress) in
            print("progress: \(progress)")
        }, successClosure: { (result) in
            print("upload success")
            print("location:\(result.location)")
            print("bucket:\(result.bucket)")
            print("key:\(result.key)")
        }) { (error) in
            print("upload error: \(error.localizedDescription)")
        }
    }
}
