//
//  GLContactsPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import Contacts
import AddressBook

public struct GLContactsPermission: GLPermissionProtocol {
    public typealias Status = CNAuthorizationStatus
    
    public var status: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    public func requestAuthorization(hanlder: @escaping (CNAuthorizationStatus) -> ()) {
        switch self.status {
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
