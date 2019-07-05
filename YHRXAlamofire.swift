//
//  YHRXAlamofire.swift
//  SwiftTool
//
//  Created by apple on 2019/7/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON




protocol YHRXAlamofireRequestProtocol {
    
}

func sada() {
    //SessionManager.default.rx
    
    request("", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        
    }.validate(statusCode: [1,2,3])
}





extension SessionManager: ReactiveCompatible {}
extension Request: ReactiveCompatible {}


extension Reactive where Base: DataRequest {
    func responseJSON() -> Observable<JSON> {
        return Observable.create({ (observer) -> Disposable in
            self.base.responseJSON(completionHandler: { (response) in
                switch response.result {
                case let .failure(error):
                    observer.on(.error(error))
                case let .success(value):
                    observer.on(.next(JSON(value)))
                }
                observer.on(.completed)
            })
            return Disposables.create {
                
            }
        })
    }
}














