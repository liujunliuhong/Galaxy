//
//  SwiftySystemImagePicker.swift
//  SwiftTool
//
//  Created by apple on 2020/6/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit


public typealias SwiftySystemImagePickerClosure = (UIImage?, [UIImagePickerController.InfoKey : Any]) -> ()

public class SwiftySystemImagePicker: NSObject {

    deinit {
        #if DEBUG
        print("\(self.classForCoder) deinit")
        #endif
    }
    
    private weak var targetViewController: UIViewController?
    
    private struct AssociatedKeys {
        static var pickerKey = "com.yinhe.SwiftySystemImagePicker.pickerKey"
        static var pickerClosureKey = "com.yinhe.SwiftySystemImagePicker.pickerClosureKey"
    }
}


extension SwiftySystemImagePicker {
    
    /// Convenient method to display system album
    /// - Parameters:
    ///   - targetViewController: targetViewController
    ///   - title: alert title
    ///   - message: alert message
    ///   - preferredStyle: alert style
    ///   - albumTitle: albumTitle
    ///   - cameraTitle: cameraTitle
    ///   - cancelTitle: cancelTitle
    ///   - closure: closure
    public static func show(targetViewController: UIViewController?, title: String?, message: String?, preferredStyle: UIAlertController.Style, albumTitle: String?, cameraTitle: String?, cancelTitle: String?, closure: SwiftySystemImagePickerClosure?) {
        guard let targetViewController = targetViewController else { return }
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let albumTitle = albumTitle {
            let albumAction = UIAlertAction(title: albumTitle, style: .default) { (_) in
                SwiftySystemImagePicker._show(targetViewController: targetViewController, sourceType: .photoLibrary, closure: closure)
            }
            alertVC.addAction(albumAction)
        }
        if let cameraTitle = cameraTitle {
            let cameraAction = UIAlertAction(title: cameraTitle, style: .default) { (_) in
                SwiftySystemImagePicker._show(targetViewController: targetViewController, sourceType: .camera, closure: closure)
            }
            alertVC.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        targetViewController.present(alertVC, animated: true, completion: nil)
    }
}

extension SwiftySystemImagePicker {
    private static func _show(targetViewController: UIViewController, sourceType: UIImagePickerController.SourceType, closure: SwiftySystemImagePickerClosure?) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return
        }
        let imagePicker = SwiftySystemImagePicker()
        imagePicker.targetViewController = targetViewController
        
        objc_setAssociatedObject(targetViewController, &SwiftySystemImagePicker.AssociatedKeys.pickerKey, imagePicker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(imagePicker, &SwiftySystemImagePicker.AssociatedKeys.pickerClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        picker.sourceType = sourceType
        picker.delegate = imagePicker
        targetViewController.present(picker, animated: true, completion: nil)
    }
}

extension SwiftySystemImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.releaseImagePicker()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        picker.dismiss(animated: true, completion: nil)
        //
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage // edit image
        let closure = objc_getAssociatedObject(self, &SwiftySystemImagePicker.AssociatedKeys.pickerClosureKey) as? SwiftySystemImagePickerClosure
        
        closure?(image, info)
        
        self.releaseImagePicker()
    }
}

extension SwiftySystemImagePicker {
    private func releaseImagePicker() {
        objc_setAssociatedObject(self, &SwiftySystemImagePicker.AssociatedKeys.pickerClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        if let targetViewController = self.targetViewController {
            objc_setAssociatedObject(targetViewController, &SwiftySystemImagePicker.AssociatedKeys.pickerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
