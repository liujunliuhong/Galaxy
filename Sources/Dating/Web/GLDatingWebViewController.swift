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

fileprivate class _TextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override var canBecomeFirstResponder: Bool {
        return false
    }
}


/// 网页类型
public enum GLDatingWebType {
    case termsOfUse(title: String?, content: String?)
    case privacyPolicy(title: String?, content: String?)
    case url(url: String?, title: String?) /// 如果为空，将会使用`webview`的`title`
}

fileprivate class GLDatingWebViewController: UIViewController {
    
    private lazy var textView: _TextView = {
        let textView = _TextView()
        textView.textAlignment = .left
        textView.isSelectable = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        if #available(iOS 11.0, *) {
            textView.interactions = []
            textView.contentInsetAdjustmentBehavior = .always
        }
        return textView
    }()
    
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
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .always
        }
        return webView
    }()
    
    private let type: GLDatingWebType
    
    init(type: GLDatingWebType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = .all
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeAction))
        
        self.view.addSubview(self.textView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        
        self.textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.progressView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + 44.0)
            make.height.equalTo(2.0)
        }
        
        switch self.type {
            case .termsOfUse(let title, let content):
                self.progressView.isHidden = true
                self.webView.isHidden = true
                self.textView.isHidden = false
                self.textView.text = content ?? defaultContent
                self.navigationItem.title = title
            case .privacyPolicy(let title, let content):
                self.progressView.isHidden = true
                self.webView.isHidden = true
                self.textView.isHidden = false
                self.textView.text = content ?? defaultContent
                self.navigationItem.title = title
            case .url(let urlString, _):
                self.progressView.isHidden = false
                self.webView.isHidden = false
                self.textView.isHidden = true
                DispatchQueue.global().async {
                    guard let urlString = urlString else { return }
                    guard let url = URL(string: urlString) else { return }
                    let request = URLRequest(url: url)
                    DispatchQueue.main.async {
                        self.webView.load(request)
                        self.observeWebView()
                    }
                }
        }
    }
    
    private func observeWebView() {
        self.webView.rx.observe(String.self, "title").subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            switch self.type {
                case .url(_, let title):
                    if let title = title {
                        self.navigationItem.title = title
                    } else {
                        self.navigationItem.title = self.webView.title
                    }
                default:
                    break
            }
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
    }
}

extension GLDatingWebViewController {
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GLDatingWebViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension GLDatingWebViewController: WKUIDelegate {
    
}

extension GLDatingWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页开始加载]")
        #endif
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页内容开始返回]")
        #endif
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        print("[Dating] [网页加载完成]")
        #endif
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        #if DEBUG
        print("[Dating] [网页加载失败]: \(error)")
        #endif
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestURL = navigationAction.request.url {
            #if DEBUG
            print("[Dating] [requestURL]\(requestURL)")
            #endif
        }
        decisionHandler(.allow)
    }
}

fileprivate class _Navi: UINavigationController {
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarUpdateAnimation
        }
        return self.viewControllers.last?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    override var childForStatusBarHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var childForStatusBarStyle: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredStatusBarStyle
        }
        return self.viewControllers.last?.preferredStatusBarStyle ?? .lightContent
    }
    
    override var shouldAutorotate: Bool {
        if let childVC = self.topViewController?.children.last {
            return childVC.shouldAutorotate
        }
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        if let childVC = self.topViewController?.children.last {
            return childVC
        }
        return self.viewControllers.last
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let childVC = self.topViewController?.children.last {
            return childVC.supportedInterfaceOrientations
        }
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let childVC = self.topViewController?.children.last {
            return childVC.preferredInterfaceOrientationForPresentation
        }
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

public class GLDatingWeb {
    /// 显示Web
    public static func show(with target: UIViewController?, type: GLDatingWebType) {
        let vc = GLDatingWebViewController(type: type)
        let navi = _Navi(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        target?.present(navi, animated: true, completion: nil)
    }
}

private let defaultContent =
    """
This application respects and protects the privacy of all users who use the service. In order to provide you with more accurate and personalized services, this application will use and disclose your personal information in accordance with the provisions of this privacy policy. However, this application will treat this information with a high degree of diligence and prudence. Except as otherwise provided in this privacy policy, the application will not disclose or provide such information to third parties without your prior permission. This application will update this privacy policy from time to time. When you agree to this application service usage agreement, you are deemed to have agreed to the full content of this privacy policy. This privacy policy is an integral part of the application agreement for the application service.
Scope of application
(a) when you register this application account, you provide personal registration information according to the application requirements;
(b) When you use the application network service or visit the web pages of the application platform, the application automatically receives and records information on your browser and computer, including but not limited to your IP address, browser type, language used, date and time of access, software and hardware features, and web page records of your needs. Such as data;
User’s personal data obtained from business partners through legitimate means.
You understand and agree that the following information is not applicable to this Privacy Policy:
(a) the keyword information you enter when you use the search service provided by this application platform;
(b) The relevant information and data collected by this application, including but not limited to participatory activities, transaction information and evaluation details, are published by you in this application;
Violations of laws or violations of the rules of application and the measures that have been taken to you in this application.
Information use
(a) The application will not provide, sell, rent, share or trade your personal information to any unrelated third party unless prior permission is obtained from you, or the third party and the application (including its affiliates) alone or jointly provide services for you, and after the end of the service, access will be prohibited, including its previous capabilities. Enough access to all of these information.
(b) This application also does not allow any third party to collect, edit, sell or disseminate your personal information free of charge by any means. If any user of this application platform engages in the above activities, the application has the right to terminate the service agreement with that user immediately upon discovery.
For the purpose of serving users, the application may use your personal information to provide you with information of interest, including, but not limited to, products and services, or to share information with the application partners so that they can send you information about their products and services (the latter requires your prior agreement). Meaning).
information disclosure
In the following cases, this application will disclose your personal information in whole or in part according to your personal wishes or legal provisions:
(a) to be disclosed to the third party through your prior consent.
(b) you must share your personal information with the third party in order to provide the products and services you require.
_Disclosure to third parties or administrative or judicial bodies in accordance with the relevant provisions of the law or the requirements of administrative or judicial bodies;
(d) If you violate the relevant laws and regulations of China or this application service agreement or relevant rules, you need to disclose them to a third party;
(e) If you are a qualified intellectual property complaint and have lodged a complaint, you should disclose it to the respondent at the request of the respondent so that both parties can handle possible rights disputes;
(f) In a transaction created on this application platform, if either party has fulfilled or partially fulfilled its trading obligations and made a request for information disclosure, the application has the right to decide to provide the user with necessary information such as the contact mode of the other party of the transaction, so as to facilitate the completion of the transaction or the settlement of disputes.
(g) other applications that are considered appropriate according to laws, regulations or website policies.
Information storage and exchange
The information and data collected by this application will be stored on the server of this application and/or its affiliated company. These information and data may be transmitted to your country, region or overseas where the information and data collected by this application are located and accessed, stored and displayed abroad.
The use of Cookie
(a) If you do not refuse to accept cookies, the application will set or access cookies on your computer so that you can log in or use cookies-dependent application platform services or functions. The application of cookies can provide you with more thoughtful personalized services, including promotion services.
(b) you have the right to choose to accept or reject cookies. You can refuse to accept cookies by modifying browser settings. But if you choose to reject cookies, you may not be able to log in or use cookies-dependent native application network services or functions.
This policy will apply to information obtained by cookies in this application.
information safety
(a) this application account has security protection function. Please keep your user name and password information properly. This application will ensure that your information is not lost, abused and altered by encrypting user passwords and other security measures. Despite the aforementioned security measures, please also note that there is no “perfect security measures” on the information network.
(b) When using this application network service for online transactions, you will inevitably have to deal with the counterparty or potential transaction pairs.
7. changes in privacy policy

(a) If we decide to change our privacy policy, we will publish these changes in this policy, on our website and where we think appropriate, so that you can understand how we collect and use your personal information, who can access it, and under what circumstances we will disclose it.

(b) our company reserves the right to modify this policy at any time, so please check it regularly. If a major change is made to the policy, the company will inform it through the form of website notice.

Please properly protect your personal information and provide it to others only if necessary. If you find that your personal information is leaked, especially the username and password of the application, please contact the application customer service immediately so that the application can take appropriate measures.

If you have any questions about this policy or other related matters, please contact us. You can also send your questions to live_org@gmail.com.
"""
