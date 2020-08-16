//
//  SwiftyFlowItemsTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 galaxy. All rights reserved.
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

public class SwiftyFlowItemsTestViewController: UIViewController {

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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let model1 = Model(title: "Auto Width", selector: #selector(autoWidthAction))
        let model2 = Model(title: "Auto Margin", selector: #selector(autoMarginAction))
        
        self.dataSource = [model1,
                           model2]
        
        if #available(iOS 13.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
    }
}

extension SwiftyFlowItemsTestViewController {
    @objc private func autoWidthAction() {
        let vc = SwiftyFlowItemsAutoWidthTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func autoMarginAction() {
        let vc = SwiftyFlowItemsAutoMarginTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SwiftyFlowItemsTestViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID")
        let model = self.dataSource[indexPath.row]
        cell?.textLabel?.text = model.title
        return cell!
    }
}

extension SwiftyFlowItemsTestViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        self.perform(model.selector)
    }
}



