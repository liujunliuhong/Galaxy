//
//  SwiftyMBHUDTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/12.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit


fileprivate enum Type {
    case tips
    case image(imageType: SwiftyMBHUDType)
    case loading
}

fileprivate struct Model {
    let message: String
    let type: Type
    init(message: String, type: Type) {
        self.message = message
        self.type = type
    }
}

public class SwiftyMBHUDTestViewController: UIViewController {
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
    
    private lazy var dataSource: [Model] = {
        let models: [Model] = [
            Model(message: "This is a tips", type: .tips),
            Model(message: "This is a success", type: .image(imageType: .success)),
            Model(message: "This is a error", type: .image(imageType: .error)),
            Model(message: "This is a info", type: .image(imageType: .info)),
            Model(message: "This is a warn", type: .image(imageType: .warn)),
            Model(message: "This is a loading", type: .loading),
        ]
        return models
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        if #available(iOS 13.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
    }
}


extension SwiftyMBHUDTestViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID")!
        let model = self.dataSource[indexPath.row]
        cell.textLabel?.text = model.message
        return cell
    }
}

extension SwiftyMBHUDTestViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        switch model.type {
        case .tips:
            SwiftyMBHUD.showTips(message: model.message)
        case .image(let imageType):
            SwiftyMBHUD.showImageHUD(message: model.message, type: imageType)
        case .loading:
            let hud = SwiftyMBHUD.showLoading(message: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SwiftyMBHUD.hide(hud: hud)
            }
        }
    }
}
