//
//  SwiftyQCloudCOSManager.swift
//  SwiftTool
//
//  Created by apple on 2020/6/4.
//  Copyright © 2020 galaxy. All rights reserved.
//

import Foundation
import QCloudCore
import QCloudCOSXML

// configuration
public typealias SwiftyQCloudCOSServiceConfiguration = (QCloudServiceConfiguration) -> ()

// upload
public typealias SwiftyQCloudCOSUploadConfiguration = (QCloudCOSXMLUploadObjectRequest<AnyObject>) -> ()
public typealias SwiftyQCloudCOSUploadProgressClosure = (CGFloat) -> ()
public typealias SwiftyQCloudCOSUploadSuccessClosure = (QCloudUploadObjectResult) -> ()
public typealias SwiftyQCloudCOSUploadErrorClosure = (Error) -> ()

// authentationType
public enum SwiftyQCloudCOSAuthentationType {
    case temporary(secretID: String?, secretKey: String?, token: String?, startDate: Date?, experationDate: Date?)
    case forever(secretID: String?, secretKey: String?)
}

/// ⚠️https://cloud.tencent.com/document/product/436/11280
/// ⚠️pod 'QCloudCOSXML'
public class SwiftyQCloudCOSManager: NSObject {
    public static let `default` = SwiftyQCloudCOSManager()
    
    public private(set) var authentationType: SwiftyQCloudCOSAuthentationType = .forever(secretID: nil, secretKey: nil)
    
    private override init() {
        super.init()
    }
}

extension SwiftyQCloudCOSManager: QCloudSignatureProvider {
    public func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        let cre = QCloudCredential()
        
        switch self.authentationType {
        case .forever(let secretID, let secretKey):
            cre.secretID = secretID ?? ""
            cre.secretKey = secretKey ?? ""
        case .temporary(let secretID, let secretKey, let token, let startDate, let experationDate):
            cre.secretID = secretID ?? ""
            cre.secretKey = secretKey ?? ""
            cre.token = token ?? ""
            if let startDate = startDate {
                cre.startDate = startDate
            }
            if let experationDate = experationDate {
                cre.experationDate = experationDate
            }
        }
        
        let auth = QCloudAuthentationV5Creator(credential: cre)
        let signature = auth?.signature(forData: urlRequst)
        continueBlock(signature, nil);
    }
}

extension SwiftyQCloudCOSManager {
    
    /// setup
    /// - Parameter serviceConfiguration: configuration
    public func setup(with serviceConfiguration: SwiftyQCloudCOSServiceConfiguration) {
        let config = QCloudServiceConfiguration()
        config.signatureProvider = self
        serviceConfiguration(config)
        
        QCloudCOSXMLService.registerDefaultCOSXML(with: config)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config)
        
        QCloudLogger.shared()?.logLevel = .none // no log
    }
    
    
    /// update authentationType
    /// - Parameter authentationType: authentationType
    public func update(authentationType: SwiftyQCloudCOSAuthentationType) {
        self.authentationType = authentationType
    }
    
    /// upload
    /// - Parameters:
    ///   - path: path
    ///   - bucketName: bucket name
    ///   - key: key
    ///   - configuration: configuration
    ///   - progressClosure: progress
    ///   - successClosure: success
    ///   - errorClosure: error
    /// - Returns: QCloudCOSXMLUploadObjectRequest
    @discardableResult public func upload(path: String, bucketName: String, key: String, configuration: SwiftyQCloudCOSUploadConfiguration?, progressClosure: SwiftyQCloudCOSUploadProgressClosure?, successClosure: SwiftyQCloudCOSUploadSuccessClosure?, errorClosure: SwiftyQCloudCOSUploadErrorClosure?) -> QCloudCOSXMLUploadObjectRequest<AnyObject> {
        
        let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        uploadRequest.body = URL(fileURLWithPath: path) as AnyObject
        uploadRequest.bucket = bucketName
        uploadRequest.object = key
        
        configuration?(uploadRequest)
        
        uploadRequest.sendProcessBlock = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) in
            DispatchQueue.main.async {
                var p: CGFloat = 0.0
                if totalBytesExpectedToSend > 0 {
                    p = CGFloat(totalBytesSent / totalBytesExpectedToSend)
                }
                if !p.isLessThanOrEqualTo(1.0) {
                    p = 1.0
                }
                progressClosure?(p)
            }
        }
        uploadRequest.setFinish { (result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    errorClosure?(error)
                } else if let result = result {
                    successClosure?(result)
                }
            }
        }
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest)
        return uploadRequest
    }
}
