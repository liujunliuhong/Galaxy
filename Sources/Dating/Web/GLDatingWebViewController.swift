//
//  GLDatingWebViewController.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

public class GLDatingWebViewController: UIViewController {
    
    /// 网页类型，如果`title`为空，将会监控`webView`的`title`属性
    public enum WebType {
        case termsOfUse(title: String?)
        case privacyPolicy(title: String?)
        case url(url: String?, title: String?)
    }
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.5)
        progressView.tintColor = .clear
        progressView.trackTintColor = .clear
        progressView.progressTintColor = UIColor(red: 255.0/255.0, green: 129.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        return progressView
    }()
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    private let type: GLDatingWebViewController.WebType
    
    private init(with type: GLDatingWebViewController.WebType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .all
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeAction))
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        
        self.webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + 44.0)
        }
        self.progressView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + 44.0)
            make.height.equalTo(2.0)
        }
        
        self.observeTitle()
        
        self.webView.rx.observe(String.self, "title").subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.observeTitle()
        }).disposed(by: rx.disposeBag)
        
        self.webView.rx.observe(CGFloat.self, "estimatedProgress").subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let progress = self.webView.estimatedProgress
            self.progressView.alpha = 1.0
            DispatchQueue.main.async {
                self.progressView.setProgress(Float(progress), animated: true)
                if progress >= 1.0 {
                    self.progressView.isHidden = true
                    self.progressView.progress = 0.0
                } else {
                    self.progressView.isHidden = false
                }
            }
        }).disposed(by: rx.disposeBag)
        
        
        switch self.type {
        case .termsOfUse:
            DispatchQueue.global().async {
                guard let path = Bundle(for: GLDatingWebViewController.classForCoder()).path(forResource: "GLDatingWeb", ofType: "bundle") else { return }
                guard let bundle = Bundle(path: path) else { return }
                guard let htmlPath = bundle.path(forResource: "terms", ofType: "html") else { return }
                let url = URL(fileURLWithPath: htmlPath)
                let request = URLRequest(url: url)
                DispatchQueue.main.async {
                    self.webView.load(request)
                }
            }
        case .privacyPolicy:
            DispatchQueue.global().async {
                guard let path = Bundle(for: GLDatingWebViewController.classForCoder()).path(forResource: "GLDatingWeb", ofType: "bundle") else { return }
                guard let bundle = Bundle(path: path) else { return }
                guard let htmlPath = bundle.path(forResource: "privacy", ofType: "html") else { return }
                let url = URL(fileURLWithPath: htmlPath)
                let request = URLRequest(url: url)
                DispatchQueue.main.async {
                    self.webView.load(request)
                }
            }
        case .url(let urlString, _):
            DispatchQueue.global().async {
                guard let urlString = urlString else { return }
                guard let url = URL(string: urlString) else { return }
                let request = URLRequest(url: url)
                DispatchQueue.main.async {
                    self.webView.load(request)
                }
            }
        }
    }
    
    private func observeTitle() {
        switch self.type {
        case .termsOfUse(let title):
            if let title = title {
                self.navigationItem.title = title
            } else {
                self.navigationItem.title = self.webView.title
            }
        case .privacyPolicy(let title):
            if let title = title {
                self.navigationItem.title = title
            } else {
                self.navigationItem.title = self.webView.title
            }
        case .url(_, let title):
            if let title = title {
                self.navigationItem.title = title
            } else {
                self.navigationItem.title = self.webView.title
            }
        }
    }
}

extension GLDatingWebViewController {
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GLDatingWebViewController {
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension GLDatingWebViewController: WKUIDelegate {
    
}

extension GLDatingWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页开始加载]")
        #endif
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页内容开始返回]")
        #endif
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页加载完成]")
        #endif
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        #if DEBUG
        print("[Dating] [网页加载失败]: \(error)")
        #endif
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestURL = navigationAction.request.url {
            #if DEBUG
            print("[Dating] [requestURL]\(requestURL)")
            #endif
        }
        decisionHandler(.allow)
    }
}

fileprivate class _Navi: UINavigationController {
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarUpdateAnimation
        }
        return self.viewControllers.last?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarStyle
        }
        return self.viewControllers.last?.preferredStatusBarStyle ?? .lightContent
    }
    
    open override var shouldAutorotate: Bool {
        if let childVC = self.topViewController?.children.last {
            return childVC.shouldAutorotate
        }
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let childVC = self.topViewController?.children.last {
            return childVC.supportedInterfaceOrientations
        }
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .all
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredInterfaceOrientationForPresentation
        }
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

extension GLDatingWebViewController {
    /// 显示Web
    public static func show(with target: UIViewController?, type: GLDatingWebViewController.WebType) {
        let vc = GLDatingWebViewController(with: type)
        let navi = _Navi(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        target?.present(navi, animated: true, completion: nil)
    }
}
