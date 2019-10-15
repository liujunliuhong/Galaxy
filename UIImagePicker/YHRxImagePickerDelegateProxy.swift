//
//  YHRxImagePickerDelegateProxy.swift
//  FNDating
//
//  Created by apple on 2019/9/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class YHRxImagePickerDelegateProxy:
    DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate&UINavigationControllerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: YHRxImagePickerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { (p) -> YHRxImagePickerDelegateProxy in
            return YHRxImagePickerDelegateProxy(imagePicker: p)
        }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}


extension Reactive where Base: UIImagePickerController {
    public var yh_pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate&UINavigationControllerDelegate> {
        return YHRxImagePickerDelegateProxy.proxy(for: base)
    }
    
    public var yh_didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
        return yh_pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) -> Dictionary<String, AnyObject> in
                /*
                 [<UIImagePickerController: 0x12c115800>,
                 {UIImagePickerControllerCropRect = "NSRect: {{0, 452}, {1241.9999629855165, 1243}}";
                  UIImagePickerControllerEditedImage = "<UIImage: 0x28310f720> size {1239, 1242} orientation 0 scale 1.000000";
                  UIImagePickerControllerImageURL = "file:///private/var/mobile/Containers/Data/Application/B02F7FB4-079A-42F1-A5F2-3175A2ED3DE5/tmp/E3EA767F-D6D9-4A3D-97B8-3AAF5E6C9943.png";
                  UIImagePickerControllerMediaType = "public.image";
                  UIImagePickerControllerOriginalImage = "<UIImage: 0x28310edf0> size {1242, 2208} orientation 0 scale 1.000000";
                  UIImagePickerControllerReferenceURL = "assets-library://asset/asset.PNG?id=E0C7F012-65BE-4F63-B529-DE6C28A16937&ext=PNG";
                 }]
                 */
                // a[1] 其实是数组里面的那个字典
                return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }
    
    public var yh_didCancel: Observable<Void> {
        return yh_pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:))).map{_ in }
    }
}


extension Reactive where Base: UIImagePickerController {
    
    public static func yh_showImagePicker(parent: UIViewController, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void) -> Observable<UIImagePickerController> {
        
        return Observable<UIImagePickerController>.create({ [weak parent] (observer) -> Disposable in
            
            // 初始化一个图片选择控制器
            let imagePicker = UIImagePickerController()
            
            // 不管图片选择完毕还是取消选择，都会自动关闭图片选择控制器
            let dismissDisposable = imagePicker.rx
                .yh_didCancel
                .subscribe(onNext: { [weak imagePicker] (_) in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            
            // 设置图片选择控制器初始参数，参数不正确则发出.error事件
            do {
                try configureImagePicker(imagePicker)
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            // 判断parent是否存在，不存在则发出.completed事件
            guard let parent = parent else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            // 弹出控制器，显示界面
            parent.present(imagePicker, animated: animated, completion: nil)
            // 发出next事件（携带的是控制器对象）
            observer.onNext(imagePicker)
            
            // 销毁时自动退出图片控制器
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        })
    }
}


//转类型的函数（转换失败后，会发出Error）
fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}


fileprivate func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}



