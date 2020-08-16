//
//  UIView+SwiftyExtensionForSnapshot.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 galaxy. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    /// Intercept the specified area of the view
    /// - Parameter targetRect: specific area
    /// - Returns: UIImage
    func yh_snapshot(targetRect: CGRect) -> UIImage? {
        let scale: CGFloat = UIScreen.main.scale // Setting the screen magnification can guarantee the quality of screenshots
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, scale)
        guard let context = UIGraphicsGetCurrentContext() else { // This code cannot be written in front of `UIGraphicsBeginImageContextWithOptions`, otherwise `context` is nil
            return nil
        }
        self.layer.render(in: context)
        defer {
            UIGraphicsEndImageContext()
        }
        let targetRect = CGRect(x: targetRect.origin.x * scale, y: targetRect.origin.y * scale, width: targetRect.width * scale, height: targetRect.height * scale)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        guard let cgImage = image.cgImage?.cropping(to: targetRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
