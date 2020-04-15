//
//  YHRxErrorTracker.swift
//  FNDating
//
//  Created by apple on 2019/10/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa


/*
 final:
 1、只能修饰类，表明该类不能被其他类继承，也就是它没资格当父类
 2、也可以修饰类中的属性、方法和下标，但前提是该类并没有被final修饰过
 3、不能修饰结构体和枚举
 */
// 参考:https://github.com/brunomorgado/RxErrorTracker
public final class YHRxErrorTracker: SharedSequenceConvertibleType {
    deinit {
        _subject.onCompleted()
    }
    
    public typealias SharingStrategy = DriverSharingStrategy
    public typealias Element = Error
    
    private let _subject = PublishSubject<Error>()
    
    
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, YHRxErrorTracker.Element> {
        return _subject.asObservable().asDriver(onErrorJustReturn: YHRxError())
    }
    
    public func asObservable() -> Observable<YHRxErrorTracker.Element> {
        return _subject.asObservable()
    }
}


extension YHRxErrorTracker {
    /*
     do：当 Observable 产生某些事件时，执行某个操作
     此处当产生error事件时，做了处理
     */
    public func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: { [weak self] (error) in
            self?._subject.onNext(error)
        })
    }
}


/*
 ObservableConvertibleType：位于`RxSwift - ObservableConvertibleType.swift`文件，是一个协议
 */
extension ObservableConvertibleType {
    public func yh_trackError(errorTracker: YHRxErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
#endif
