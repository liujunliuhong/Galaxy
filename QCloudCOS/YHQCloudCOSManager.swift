//
//  YHQCloudCOSManager.swift
//  TMM
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
#if (canImport(QCloudCore) && canImport(QCloudCOSXML))
import QCloudCore
import QCloudCOSXML
#endif

#if (canImport(QCloudCore) && canImport(QCloudCOSXML))
@objc public class YHQCloudCOSManager: NSObject {
    
    private let credentialFenceQueue: QCloudCredentailFenceQueue
    
    public override init() {
        self.credentialFenceQueue = QCloudCredentailFenceQueue()
        super.init()
        self.credentialFenceQueue.delegate = self
    }
    
    @objc public static let `default` = YHQCloudCOSManager()
    
    private var secretID: String?
    private var secretKey: String?
    
    @objc public func setup(appID: String, regionName: String, secretID: String, secretKey: String) {
        self.secretID = secretID
        self.secretKey = secretKey
        
        let config = QCloudServiceConfiguration()
        config.signatureProvider = self
        config.appID = appID
        
        let endpoint = QCloudCOSXMLEndPoint.init()
        endpoint.regionName = regionName
        endpoint.useHTTPS = true
        config.endpoint = endpoint
        
        QCloudCOSXMLService.registerDefaultCOSXML(with: config)
        
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config)
        
        QCloudLogger.shared()?.logLevel = .none
    }
}

extension YHQCloudCOSManager: QCloudSignatureProvider {
    public func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        let cre = QCloudCredential()
        cre.secretID = self.secretID!
        cre.secretKey = self.secretKey!
        let auth = QCloudAuthentationV5Creator(credential: cre)
        let signature = auth?.signature(forData: urlRequst)
        continueBlock(signature,nil);
    }
}

extension YHQCloudCOSManager: QCloudCredentailFenceQueueDelegate {
    public func fenceQueue(_ queue: QCloudCredentailFenceQueue!, requestCreatorWithContinue continueBlock: QCloudCredentailFenceQueueContinue!) {
        let cre = QCloudCredential()
        cre.secretID = self.secretID
        cre.secretKey = self.secretKey
        let auth = QCloudAuthentationV5Creator(credential: cre)
        continueBlock(auth,nil);
    }
}


extension YHQCloudCOSManager {
    @objc public func upload(with path: String, bucketName: String, key: String, progressClosure: ((CGFloat)->())?, successClosure: ((QCloudUploadObjectResult)->())?, errorClosure: ((Error)->())?) {
        let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        uploadRequest.customHeaders = ["content-type": ""]
        uploadRequest.body = URL(fileURLWithPath: path) as AnyObject
        uploadRequest.bucket = bucketName
        uploadRequest.object = key
        
        uploadRequest.sendProcessBlock = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) in
            if totalBytesExpectedToSend <= 0 {
                let progress: CGFloat = 0.0
                progressClosure?(progress)
            } else {
                let progress = CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend)
                progressClosure?(progress)
            }
        }
        
        uploadRequest.setFinish { (result, error) in
            if result != nil {
                #if DEBUG
                print("===============================================")
                print("location:\(result!.location)")
                print("bucket:\(result!.bucket)")
                print("key:\(result!.key)")
                print("===============================================")
                #endif
                successClosure?(result!)
            }
            if error != nil {
                errorClosure?(error!)
            }
        }
        
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest)
    }
}
#endif
