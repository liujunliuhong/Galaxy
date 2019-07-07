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



protocol YHRXAlamofireRequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var isShowHUD: Bool { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var hudShowInView: UIView { get }
    var timeOutInterval: TimeInterval { get }
}


//func sada() {
//    //SessionManager.default.rx
//    SessionManager.default.rx.yh_httpRequest(request: sdasada()).flatMap{ $0.rx.responseJSON() }.subscribe(onNext: { (json) in
//
//    }, onError: { (error) in
//
//    }, onCompleted: {
//
//    }) {
//
//    }.dispose()
//
//
//    request("", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//
//    }.validate(statusCode: [1,2,3])
//}
//




extension SessionManager: ReactiveCompatible {}
extension Request: ReactiveCompatible {}

private let yh_rx_disposeBag = DisposeBag()

struct YHRXAlamofire {
    
    static func requestJSON(request: YHRXAlamofireRequestProtocol) -> Observable<(JSON, Float)> {
        return Observable<(JSON, Float)>.create({ (observer) -> Disposable in
            
            SessionManager.default.rx.yh_httpRequest(request: request).observeOn(MainScheduler.instance).flatMap({ (dataRequest) -> Observable<(JSON, Float)> in
                
                let progressPart = dataRequest.rx.yh_progress()
                
                let jsonPart = dataRequest.rx.yh_responseString()
                
                
                
                print("开始请求")
                progressPart.observeOn(MainScheduler.instance).subscribe(onNext: { (p) in
                    print("进度:\(p)")
                }, onCompleted: {
                    print("进度停止")
                }).disposed(by: yh_rx_disposeBag)
                
                
                return Observable<(JSON, Float)>.combineLatest(jsonPart, progressPart){ (JSON($0), $1) }
            }).observeOn(MainScheduler.instance).subscribe(onNext: { (json, progress) in
                observer.onNext((json, progress))
            }, onError: { (error) in
                observer.onError(error)
            }, onCompleted: {
                observer.onCompleted()
            }).disposed(by: yh_rx_disposeBag)
            
            return Disposables.create()
        })
    }
}





extension Reactive where Base: SessionManager {
    
    func yh_httpRequest(request: YHRXAlamofireRequestProtocol) -> Observable<DataRequest> {
        return Observable<DataRequest>.create({ (observer) -> Disposable in
            
            let request = self.base.request(String(target: request), method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            
            if !self.base.startRequestsImmediately {
                request.resume()
            }
            
            observer.onNext(request)
            observer.onCompleted()
            
            return Disposables.create {
//                request.cancel()
            }
        })
    }
}

extension String {
    init(target: YHRXAlamofireRequestProtocol) {
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = "\(target.baseURL)\(target.path)"
        }
    }
}



extension Reactive where Base: DataRequest {
    func yh_responseJSON() -> Observable<JSON> {
        return Observable.create({ (observer) -> Disposable  in
            self.base.responseJSON(completionHandler: { (response) in
                switch response.result {
                case let .failure(error):
                    observer.onError(error)
                case let .success(value):
                    observer.onNext(JSON(value))
                }
                observer.onCompleted()
            })
            return Disposables.create {
                self.base.cancel()
            }
        })
    }
    
    
    func yh_responseString() -> Observable<String> {
        return Observable<String>.create({ (observer) -> Disposable in
            self.base.responseString(completionHandler: { (response) in
                switch response.result {
                case let .failure(error):
                    observer.onError(error)
                case let .success(value):
                    observer.onNext(value)
                }
                observer.onCompleted()
            })
            return Disposables.create {
                self.base.cancel()
            }
        })
    }
    
    func yh_responseData() -> Observable<Data> {
        return Observable<Data>.create({ (observer) -> Disposable in
            self.base.responseData(completionHandler: { (response) in
                switch response.result {
                case let .failure(error):
                    observer.onError(error)
                case let .success(value):
                    observer.onNext(value)
                }
                observer.onCompleted()
            })
            return Disposables.create {
                self.base.cancel()
            }
        })
    }
}


extension Reactive where Base: Request {
    func yh_progress() -> Observable<Float> {
        return Observable<Float>.create({ (observer) -> Disposable in
            
            let handler: Request.ProgressHandler = { progress in
                if progress.totalUnitCount <= 0 {
                    observer.onNext(0.0)
                } else {
                    observer.onNext(Float(progress.completedUnitCount) / Float(progress.totalUnitCount))
                }
//                if progress.completedUnitCount >= progress.totalUnitCount {
//                    observer.onCompleted()
//                }
            }
            
            if let dataRequest = self.base as? DataRequest {
                dataRequest.downloadProgress(closure: handler)
            } else if let downloadRequest = self.base as? DownloadRequest {
                downloadRequest.downloadProgress(closure: handler)
            } else if let uploadRequest = self.base as? UploadRequest {
                uploadRequest.uploadProgress(closure: handler)
            }
            
            return Disposables.create()
        })
    }
}











