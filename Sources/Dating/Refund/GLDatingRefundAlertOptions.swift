//
//  GLDatingRefundAlertOptions.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class GLDatingRefundAlertOptions {
    public var backgroundColor: UIColor = UIColor.gl_color(string: "#1B1B1B")
    public var buttonColor: UIColor = UIColor.gl_color(string: "#FF12B4")
    public var textColor: UIColor = UIColor.gl_white
    public var clickRefundClosure: (() -> Void)?
    public var refundSendSuccessClosure: (() -> Void)?
    public var clickSuggestionsClosure: (() -> Void)?
    public var suggestionsSendSuccessClosure: (() -> Void)?
    public var successImage: UIImage?
    public init() {}
}
