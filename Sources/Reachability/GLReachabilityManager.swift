//
//  GLReachabilityManager.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public class GLReachabilityManager {
    public static let `default` = GLReachabilityManager()
    
    public private(set) lazy var reachabilityManager = Alamofire.NetworkReachabilityManager()
    
    public var isReachable: Bool {
        return self.reachabilityManager?.isReachable ?? false
    }
    
    public var isReachableOnCellular: Bool {
        return self.reachabilityManager?.isReachableOnCellular ?? false
    }
    
    public var isReachableOnEthernetOrWiFi: Bool {
        return self.reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
    
    private init() {
        
    }
}

extension GLReachabilityManager {
    /// 开启网络状态监控
    public func startListeningNetwork() {
        self.reachabilityManager?.startListening(onQueue: .main, onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                print("[GLReachabilityManager] [network notReachable]")
            case .unknown:
                print("[GLReachabilityManager] [network unknown]")
            case .reachable(let type):
                switch type {
                case .ethernetOrWiFi:
                    print("[GLReachabilityManager] [network reachable via ethernetOrWiFi]")
                case .cellular:
                    print("[GLReachabilityManager] [network reachable via cellular]")
                }
            }
        })
    }
    
    /// 停止网络状态监控
    public func stopListeningNetwork() {
        self.reachabilityManager?.stopListening()
    }
}
