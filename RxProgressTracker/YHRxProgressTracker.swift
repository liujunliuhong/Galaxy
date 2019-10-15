//
//  YHRxProgressTracker.swift
//  FNDating
//
//  Created by apple on 2019/10/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


private struct YHRxProgressToken<O>: ObservableConvertibleType, Disposable {
    
    typealias Element = O
    
    private let _source: Observable<O>
    private let _dispose: Cancelable
    
    init(source: Observable<O>, disposeAction: (() -> Void)?) {
        _source = source
        
        if let disposeAction = disposeAction {
            _dispose = Disposables.create(with: disposeAction)
        } else {
            _dispose = Disposables.create {}
        }
    }
    
    // 实现Disposable协议
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<O> {
        return _source
    }
}


public class YHRxProgressTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    public typealias Element = Bool
    
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay<Int>(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        _loading = _relay.asDriver()
            .map({ (value) -> Bool in
                return value > 0
            }).distinctUntilChanged()
    }
    
    // 实现SharedSequenceConvertibleType协议
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        return _loading
    }
    
    private func increment() {
        _lock.lock()
        let a = _relay.value
        _relay.accept(a + 1)
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        let a = _relay.value
        _relay.accept(a - 1)
        _lock.unlock()
        
    }
}


extension YHRxProgressTracker {
    public func trackProgress<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        /*
        using:创建一个可被清除的资源，它和 Observable 具有相同的寿命
        通过使用 using 操作符创建 Observable 时，同时创建一个可被清除的资源，一旦 Observable 终止了，那么这个资源就会被清除掉了
        */
        return Observable<O.Element>.using({ [weak self] () -> YHRxProgressToken<O.Element> in
            guard let self = self else { return YHRxProgressToken<O.Element>(source: source.asObservable(), disposeAction: nil) }
            self.increment()
            return YHRxProgressToken<O.Element>(source: source.asObservable(), disposeAction: self.decrement)
        }) { (disposable) -> Observable<O.Element> in
            return disposable.asObservable()
        }
    }
}



extension ObservableConvertibleType {
    public func yh_trackProgress(progressTracker: YHRxProgressTracker) -> Observable<Element> {
        return progressTracker.trackProgress(from: self)
    }
}



/*************************************************************************
 
 useage:
 
 struct TestError: Error {
     var localizedDescription: String {
         return "错误测试"
     }
 }
 
 
 let isLoading = YHRxProgressTracker()
 let error = YHRxErrorTracker()
 
 
 let observer = Observable<Int>.create { (o) -> Disposable in
     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         o.onNext(123)
         o.onError(TestError())
         o.onCompleted()
     }
     return Disposables.create()
 }
 
 observer
     .yh_trackProgress(progressTracker: isLoading)
     .yh_trackError(errorTracker: error)
     .subscribe(onNext: { (value) in
         print("value: \(value)")
     }).disposed(by: rx.disposeBag)
 
 
 isLoading.drive(onNext: { (res) in
     print("\(res ? "开始loading" : "结束loading")")
 }).disposed(by: rx.disposeBag)
 
 error.drive(onNext: { (error) in
     print("收到error: \(error)")
 }).disposed(by: rx.disposeBag)
 
 *************************************************************************/
