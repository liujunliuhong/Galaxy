//
//  GLDatingRefundMakeSuggestionsViewModel.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

internal class GLDatingRefundMakeSuggestionsViewModel: NSObject {
    
    var suggestions: String?
    
    
    let clickCancelTrigger = PublishSubject<Void>()
    let clickSubmitTrigger = PublishSubject<Void>()
    let submitSuccessTrigger = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        self.clickSubmitTrigger.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let suggestions = self.suggestions ?? ""
            if suggestions.isEmpty {
                GLHud.showTips(message: "Please enter suggestions", type: .info)
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

