//
//  GLContactsPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import Contacts

public struct GLContactsPermission {}

extension GLContactsPermission: GLPermissionProtocol {
    public typealias Status = CNAuthorizationStatus
    
    public static var authorizationStatus: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    public static func requestAuthorization(hanlder: @escaping (CNAuthorizationStatus) -> ()) {
        switch self.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    hanlder(.authorized)
                }
            case .denied:
                DispatchQueue.main.async {
                    hanlder(.denied)
                }
            case .restricted:
                DispatchQueue.main.async {
                    hanlder(.restricted)
                }
            case .notDetermined:
                CNContactStore().requestAccess(for: .contacts) { (granted, _) in
                    DispatchQueue.main.async {
                        hanlder(granted ? .authorized : .denied)
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    hanlder(.denied)
                }
        }
    }
}
