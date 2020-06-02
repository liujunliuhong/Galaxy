//
//  SwiftyPermissionTestViewController.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate struct Model {
    let title: String
    let selector: Selector
    init(title: String, selector: Selector) {
        self.title = title
        self.selector = selector
    }
}

class SwiftyPermissionTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "ID")
        return tableView
    }()
    
    private var dataSource: [Model] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model1 = Model(title: "Camera Authorization Status", selector: #selector(getCameraAuthorizationStatus))
        let model2 = Model(title: "Request Camera Authorization", selector: #selector(requestCameraAuthorization))
        let model3 = Model(title: "Microphone Authorization Status", selector: #selector(getMicrophoneAuthorizationStatus))
        let model4 = Model(title: "Request Microphone Authorization", selector: #selector(requestMicrophoneAuthorization))
        let model5 = Model(title: "Photo Authorization Status", selector: #selector(getPhotoAuthorizationStatus))
        let model6 = Model(title: "Request Photo Authorization", selector: #selector(requestPhotoAuthorization))
        let model7 = Model(title: "Contacts Authorization Status", selector: #selector(getContactsAuthorizationStatus))
        let model8 = Model(title: "Request Contacts Authorization", selector: #selector(requestContactsAuthorization))
        let model9 = Model(title: "Reminder Authorization Status", selector: #selector(getReminderAuthorizationStatus))
        let model10 = Model(title: "Request Reminder Authorization", selector: #selector(requestReminderAuthorization))
        let model11 = Model(title: "Calendar Authorization Status", selector: #selector(getCalendarAuthorizationStatus))
        let model12 = Model(title: "Request Calendar Authorization", selector: #selector(requestCalendarAuthorization))
        
        self.dataSource = [model1,
                           model2,
                           model3,
                           model4,
                           model5,
                           model6,
                           model7,
                           model8,
                           model9,
                           model10,
                           model11,
                           model12]
        
        if #available(iOS 13.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
    }
}

// MARK: - Camera
extension SwiftyPermissionTestViewController {
    @objc private func getCameraAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .camera)
        print("camera authorized status: \(isAuthorized)")
    }
    @objc private func requestCameraAuthorization() {
        SwiftyPermission.requestAuthorization(for: .camera) { (result) in
            print("camera: \(result.debugDescription)")
        }
    }
}

// MARK: - Microphone
extension SwiftyPermissionTestViewController {
    @objc private func getMicrophoneAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .microphone)
        print("microphone authorized status: \(isAuthorized)")
    }
    @objc private func requestMicrophoneAuthorization() {
        SwiftyPermission.requestAuthorization(for: .microphone) { (result) in
            print("microphone: \(result.debugDescription)")
        }
    }
}

// MARK: - Photo
extension SwiftyPermissionTestViewController {
    @objc private func getPhotoAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .photo)
        print("photo authorized status: \(isAuthorized)")
    }
    @objc private func requestPhotoAuthorization() {
        SwiftyPermission.requestAuthorization(for: .photo) { (result) in
            print("photo: \(result.debugDescription)")
        }
    }
}

// MARK: - contacts
extension SwiftyPermissionTestViewController {
    @objc private func getContactsAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .contacts)
        print("contacts authorized status: \(isAuthorized)")
    }
    @objc private func requestContactsAuthorization() {
        SwiftyPermission.requestAuthorization(for: .contacts) { (result) in
            print("contacts: \(result.debugDescription)")
        }
    }
}


// MARK: - reminder
extension SwiftyPermissionTestViewController {
    @objc private func getReminderAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .reminder)
        print("reminder authorized status: \(isAuthorized)")
    }
    @objc private func requestReminderAuthorization() {
        SwiftyPermission.requestAuthorization(for: .reminder) { (result) in
            print("reminder: \(result.debugDescription)")
        }
    }
}


// MARK: - calendar
extension SwiftyPermissionTestViewController {
    @objc private func getCalendarAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .calendar)
        print("calendar authorized status: \(isAuthorized)")
    }
    @objc private func requestCalendarAuthorization() {
        SwiftyPermission.requestAuthorization(for: .calendar) { (result) in
            print("calendar: \(result.debugDescription)")
        }
    }
}


extension SwiftyPermissionTestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID")
        let model = self.dataSource[indexPath.row]
        cell?.textLabel?.text = model.title
        return cell!
    }
}

extension SwiftyPermissionTestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        self.perform(model.selector)
    }
}
