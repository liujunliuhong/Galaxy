//
//  GLDatingApplyForRefundViewModel.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

internal class GLDatingApplyForRefundViewModel: NSObject {
    
    var account: String?
    var name: String?
    var reason: String?
    
    
    let clickCancelTrigger = PublishSubject<Void>()
    let clickSubmitTrigger = PublishSubject<Void>()
    let submitSuccessTrigger = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        self.clickSubmitTrigger.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let account = self.account ?? ""
            let name = self.name ?? ""
            let reason = self.reason ?? ""
            if account.isEmpty {
                GLHud.showTips(message: "Please enter account", type: .info)
                return
            }
            if name.isEmpty {
                GLHud.showTips(message: "Please enter name", type: .info)
                return
            }
            if reason.isEmpty {
                GLHud.showTips(message: "Please enter reason", type: .info)
                return
            }
            let hud = GLHud.showLoading(message: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                GLHud.hide(hud: hud)
                self.submitSuccessTrigger.onNext(())
            }
        }).disposed(by: rx.disposeBag)
    }
}

