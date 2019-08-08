//
//  YHRXAlamofire.swift
//  SwiftTool
//
//  Created by apple on 2019/7/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import UIKit




public protocol YHAlamofireRequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: [String: String]? { get }
    var isShowHUD: Bool { get }
    var parameters: Alamofire.Parameters? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var timeoutInterval: TimeInterval { get }
    
    var isForceShowHUDWhenRequest: Bool { get }
    
    var isPrintLog: Bool { get }
    
    func requestBegin()
    func requestProgress(progress: Double)
    func requestEnd()
}

extension YHAlamofireRequestProtocol {
    var timeoutInterval: TimeInterval {
        return 60.0
    }
    var isPrintLog: Bool {
        return true
    }
}



class YHAlamofire {
    @discardableResult
    static func request(request: YHAlamofireRequestProtocol, sessionManager: SessionManager = Alamofire.SessionManager.default, completion:@escaping (YHResult<JSON, Error>.result) -> Void) -> DataRequest {
        var URL = request.baseURL
        if !request.path.isEmpty {
            URL = URL + request.path
        }
        
        request.requestBegin()
        request.requestProgress(progress: 0.0)
        
        let dataRequest = sessionManager.request(URL, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
        
        if let urlRequest = dataRequest.request {
            var urlRequest = urlRequest
            urlRequest.timeoutInterval = request.timeoutInterval
        }
        
        dataRequest.downloadProgress(queue: DispatchQueue.main) { (progress) in
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            if totalUnitCount > 0 {
                request.requestProgress(progress: Double(completedUnitCount / totalUnitCount))
            } else {
                request.requestProgress(progress: 0.0)
            }
            }.responseJSON { (response) in
                request.requestEnd()
                if request.isPrintLog {
                    var log = "\n=============================================================================\n"
                    log += "URL:               \(URL)\n"
                    log += "Method:            \(request.method.rawValue)\n"
                    log += "Headers:           \(request.headers ?? [:])\n"
                    log += "Parameters:        \(request.parameters ?? [:])\n"
                    log += "Encoding:          \(request.encoding)\n"
                    log += "TimeoutInterval:   \(request.timeoutInterval)\n"
                    log += "=============================================================================\n"
                    log += "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓\n"
                    if let value = response.value {
                        log += "\(value)\n"
                    }
                    if let error = response.error {
                        log += "\(error)\n"
                    }
                    log += "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑\n"
                    YHDebugLog(log)
                }
                switch response.result {
                case let .success(value):
                    let json = JSON(value)
                    request.requestProgress(progress: 1.0)
                    completion(.success(json))
                case let .failure(error):
                    request.requestProgress(progress: 1.0)
                    completion(.failure(error))
                }
            }
        return dataRequest
    }
}




extension YHAlamofire: ReactiveCompatible {}

extension Reactive where Base: YHAlamofire {
    static func requestJSON(request: YHAlamofireRequestProtocol, sessionManager: SessionManager = Alamofire.SessionManager.default) -> Observable<(JSON)> {
        return Observable<(JSON)>.create({ (observer) -> Disposable in
            
            let dataRequest = YHAlamofire.request(request: request, sessionManager: sessionManager, completion: { (result) in
                switch result.result {
                case let .success(json):
                    observer.onNext(json)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            
            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }
}











