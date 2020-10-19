//
//  GLPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

/*
 👉👉👉👉👉Please add these keys in `info.plist`.👈👈👈👈👈
 
 <key>NSRemindersUsageDescription</key>
 <string>xxxxx</string>
 <key>NSCalendarsUsageDescription</key>
 <string>xxxxx</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>xxxxx</string>
 <key>NSContactsUsageDescription</key>
 <string>xxxxx</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>xxxxx</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>xxxxx</string>
 <key>NSCameraUsageDescription</key>
 <string>xxxxx</string>
 */
public protocol GLPermissionProtocol {
    associatedtype Status
    var status: Status { get }
    func requestAuthorization(hanlder: @escaping (Status)->())
}
