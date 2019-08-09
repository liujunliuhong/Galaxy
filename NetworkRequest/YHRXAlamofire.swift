//
//  YHRXAlamofire.swift
//  SwiftTool
//
//  Created by apple on 2019/7/5.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

import MBProgressHUD
import RxSwift
import Alamofire
import SwiftyJSON
import UIKit

public protocol YHAlamofireRequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: [String: String]? { get }
    var isShowHUD: Bool { get }
    var parameters: Alamofire.Parameters? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    
    var timeoutInterval: TimeInterval { get }
    var isForceShowHUDWhenRequest: Bool { get }
    var isPrintLog: Bool { get }
    func requestBegin()
    func requestProgress(progress: Double)
    func requestEnd()
}

extension YHAlamofireRequestProtocol {
    var timeoutInterval: TimeInterval {
        return 60.0
    }
    var isPrintLog: Bool {
        return true
    }
    var isForceShowHUDWhenRequest: Bool {
        return true
    }
    func requestBegin() {}
    func requestProgress(progress: Double) {}
    func requestEnd() {}
}




class YHAlamofire {
    @discardableResult
    static func request(request: YHAlamofireRequestProtocol, sessionManager: SessionManager = Alamofire.SessionManager.default, completion:@escaping (YHResult<JSON, Error>.result) -> Void) -> DataRequest {
        var URL = request.baseURL
        if !request.path.isEmpty {
            URL = URL + request.path
        }
        
        /*
         HTTPS配置
         let configuration = URLSessionConfiguration.default
         configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
         let policies:[String: ServerTrustPolicy] = ["https://www.baidu.com":.disableEvaluation,
                                                     "https://www.baidu.com":.disableEvaluation]
         let httpsManager = SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
         httpsManager.startRequestsImmediately = false
         return httpsManager
         */
        
        
        request.requestBegin()
        request.requestProgress(progress: 0.0)
        
        var hud: MBProgressHUD? = nil
        if request.isForceShowHUDWhenRequest {
            hud = YHHUD.showMBHUD()
        }
        let dataRequest = sessionManager.request(URL, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
        
        if let urlRequest = dataRequest.request {
            var urlRequest = urlRequest
            urlRequest.timeoutInterval = request.timeoutInterval
        }
        
        dataRequest.downloadProgress(queue: DispatchQueue.main) { (progress) in
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            if totalUnitCount > 0 {
                request.requestProgress(progress: Double(completedUnitCount / totalUnitCount))
            } else {
                request.requestProgress(progress: 0.0)
            }
            }.responseJSON { (response) in
                YHHUD.hideMBHUD(hud)
                request.requestEnd()
                if request.isPrintLog {
                    var log = "\n=============================================================================\n"
                    log += "URL:               \(URL)\n"
                    log += "Method:            \(request.method.rawValue)\n"
                    log += "Headers:           \(request.headers ?? [:])\n"
                    log += "Parameters:        \(request.parameters ?? [:])\n"
                    log += "Encoding:          \(request.encoding)\n"
                    log += "TimeoutInterval:   \(request.timeoutInterval)\n"
                    log += "=============================================================================\n"
                    log += "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓\n"
                    if let value = response.value {
                        log += "\(value)\n"
                    }
                    if let error = response.error {
                        log += "\(error)\n"
                    }
                    log += "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑\n"
                    YHDebugLog(log)
                }
                switch response.result {
                case let .success(value):
                    let json = JSON(value)
                    request.requestProgress(progress: 1.0)
                    completion(.success(json))
                case let .failure(error):
                    request.requestProgress(progress: 1.0)
                    completion(.failure(error))
                }
            }
        return dataRequest
    }
}




extension YHAlamofire: ReactiveCompatible {}

extension Reactive where Base: YHAlamofire {
    static func requestJSON(request: YHAlamofireRequestProtocol, sessionManager: SessionManager = Alamofire.SessionManager.default) -> Observable<(JSON)> {
        return Observable<(JSON)>.create({ (observer) -> Disposable in
            
            let dataRequest = YHAlamofire.request(request: request, sessionManager: sessionManager, completion: { (result) in
                switch result.result {
                case let .success(json):
                    observer.onNext(json)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            
            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }
}





//import Result
//import Alamofire
//import UIKit
//import MBProgressHUD

//public protocol YHNetConfig {
//    // 是否显示HUD，默认true，基于MBProgressHUD.
//    var isShowHUD: Bool { get }
//    // 显示HUD的View,默认为keyWindow.
//    var hudShowInView: UIView { get }
//    // 是否打印请求的基本信息，默认true
//    var isPrintBaseInfo: Bool { get }
//    // 是否打印请求结果信息，默认true
//    var isPrintResponseInfo: Bool { get }
//    // 请求超时时间，默认60s
//    var timeOutInterval: TimeInterval { get }
//}
//
//extension TargetType {
//    var baseURL: URL {
//        return URL(string: "")!
//    }
//
//    var path: String {
//        return ""
//    }
//
//    var method: Moya.Method {
//        return .get
//    }
//
//    var sampleData: Data {
//        return Data()
//    }
//
//    var task: Task {
//        return .requestPlain
//    }
//
//    var validationType: ValidationType {
//        return .successCodes
//    }
//
//    var headers: [String : String]? {
//        return nil
//    }
//}
//
//extension YHNetConfig {
//    var timeOutInterval: TimeInterval {
//        return 60
//    }
//
//    var isShowHUD: Bool {
//        return true
//    }
//
//    var isPrintBaseInfo: Bool {
//        return true
//    }
//
//    var isPrintResponseInfo: Bool {
//        return true
//    }
//
//    var hudShowInView: UIView {
//        return UIApplication.shared.keyWindow!
//    }
//}
//
///// 网络状态监听器，对NetworkReachabilityManager的简单封装
//struct YHNetReachabilityManager {
//    static let shared = YHNetReachabilityManager()
//
//    let manager:NetworkReachabilityManager
//
//    init() {
//        self.manager = NetworkReachabilityManager()!
//        self.manager.listener = { (status) in
//            print("This network status is \(status)")
//        }
//    }
//
//    public func startListening() -> Void {
//        self.manager.startListening()
//    }
//
//    public  func stopListening() -> Void {
//        self.manager.stopListening()
//    }
//}
//
//
///// 提供了几个插件，方便开发与调试
//struct YHNet {
//
//    /*
//     https验证，目前为止，我所开发的项目中只有2个项目是用的https，其余全是http
//
//     static let defaultAlamofireManager: Manager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
//
//        let policies:[String: ServerTrustPolicy] = ["https://www.baidu.com":.disableEvaluation,
//                                                    "https://www.baidu.com":.disableEvaluation]
//
//        let manager = Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//        manager.startRequestsImmediately = false
//        return manager
//     }()
//
//     */
//    let config: YHNetConfig&TargetType
//
//    // 超时时间插件.
//    let timeoutPlugin: YHNetTimeoutPlugin
//
//    // 日志插件.
//    let loggerPlugin: YHNetLoggerPlugin
//
//    // loading圈插件，依赖于MBProgressHUD.
//    var activityPlugin:YHNetworkActivityPlugin
//
//
//    init(config: YHNetConfig&TargetType) {
//        self.config = config;
//        self.timeoutPlugin = YHNetTimeoutPlugin(config: config)
//        self.loggerPlugin = YHNetLoggerPlugin(config: config)
//        self.activityPlugin = YHNetworkActivityPlugin(config: config)
//    }
//}
//
//// MARK: - Activity Pkugin.
//class YHNetworkActivityPlugin: PluginType {
//
//    enum ProgressType {
//        case began
//        case end
//    }
//
//    lazy var hud: MBProgressHUD = {
//        let hud = MBProgressHUD.showAdded(to: self.config.hudShowInView, animated: true)
//        hud.mode = .indeterminate
//        hud.contentColor = .white
//        hud.bezelView.style = .solidColor
//        hud.bezelView.color = UIColor.black.withAlphaComponent(1)
//        hud.removeFromSuperViewOnHide = true
//        return hud
//    }()
//
//    var progressType: ProgressType = .began {
//        didSet {
//            if !self.config.isShowHUD {
//                return
//            }
//            switch self.progressType {
//            case .began:
//                DispatchQueue.main.async {
//                    self.hud.show(animated: true)
//                }
//            case .end:
//                DispatchQueue.main.async {
//                    self.hud.hide(animated: true)
//                }
//            }
//        }
//    }
//
//    var config: YHNetConfig&TargetType
//
//    init(config:YHNetConfig&TargetType) {
//        self.config = config
//    }
//
//    func willSend(_ request: RequestType, target: TargetType) {
//        //print("开始请求网络")
//        self.progressType = .began
//    }
//
//    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
//        //print("结束网络请求")
//        self.progressType = .end
//    }
//}
//
//
//
//// MARK: - Timeout Plugin
//struct YHNetTimeoutPlugin: PluginType {
//
//    let config: YHNetConfig&TargetType
//
//    init(config:YHNetConfig&TargetType) {
//        self.config = config
//    }
//
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        var request = request
//        request.timeoutInterval = config.timeOutInterval
//        return request
//    }
//}
//
//private struct YHNetAnyEncodable: Encodable {
//
//    private let encodable: Encodable
//
//    public init(_ encodable: Encodable) {
//        self.encodable = encodable
//    }
//
//    func encode(to encoder: Encoder) throws {
//        try encodable.encode(to: encoder)
//    }
//}
//
//
//// MARK: - Logger Plugin
//struct YHNetLoggerPlugin: PluginType {
//    let config: YHNetConfig&TargetType
//
//    init(config:YHNetConfig&TargetType) {
//        self.config = config
//    }
//
//    func willSend(_ request: RequestType, target: TargetType) {
//        if !config.isPrintBaseInfo {
//            return
//        }
//
//        var output = [String]()
//
//        guard let _ = request.request as URLRequest? else {
//            print("[👉👉👉👉👉] Invalid Request")
//            return
//        }
//
//
//        output += ["[👉👉👉👉👉] Request URL: \(target.baseURL)"]
//        output += ["[👉👉👉👉👉] Request Path: \(target.path)"]
//
//        if let headers = target.headers {
//            output += ["[👉👉👉👉👉] Request Headers: \(headers)"]
//        } else {
//            output += ["[👉👉👉👉👉] Request Headers: null"]
//        }
//        output += ["[👉👉👉👉👉] Request URL: \(target.method.rawValue)"]
//
//
//
//        var end: Any = NSNull()
//        switch target.task {
//        case let .requestData(data):
//            end = String(data: data, encoding: .utf8) ?? "null"
//        case let .requestJSONEncodable(encodable):
//            let encoder = JSONEncoder()
//            let encodable = YHNetAnyEncodable(encodable)
//            do {
//                let httpBody = try encoder.encode(encodable)
//                end = String(data: httpBody, encoding: .utf8) ?? "null"
//            } catch {
//                end = NSNull()
//            }
//        case let .requestCustomJSONEncodable(encodable, encoder: encoder):
//            let encodable = YHNetAnyEncodable(encodable)
//            do {
//                let httpBody = try encoder.encode(encodable)
//                end = String(data: httpBody, encoding: .utf8) ?? "null"
//            } catch {
//                end = NSNull()
//            }
//        case let .requestParameters(parameters, _):
//            end = parameters
//
//        case let .requestCompositeData(_, urlParameters):
//            end = urlParameters
//        case let .requestCompositeParameters(_, _, urlParameters):
//            end = urlParameters
//        case let .uploadCompositeMultipart(_, urlParameters):
//            end = urlParameters
//        case let .downloadParameters(parameters, _, _):
//            end = parameters
//        default:
//            end = NSNull()
//        }
//        output += ["[👉👉👉👉👉] Request Parameters: \(end)"]
//
//        let info = output.joined(separator: "\n")
//
//        print(info)
//    }
//
//    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
//        if !config.isPrintResponseInfo {
//            return
//        }
//        switch result {
//        case let .success(value):
//            if let json = try? value.mapJSON() {
//                print("[👉👉👉👉👉] Response To JSON:\n\(json)")
//            } else if let string = try? value.mapString() {
//                print("[👉👉👉👉👉] Response To String:\n\(string)")
//            } else if let image = try? value.mapImage() {
//                print("[👉👉👉👉👉] Response To Image:\n\(image)")
//            } else {
//                print("[👉👉👉👉👉] Response To nil")
//            }
//        case let .failure(error):
//            let errorDescription = error.errorDescription ?? "Unknown error"
//            print("[👉👉👉👉👉] Request Error: \(errorDescription)")
//        }
//    }
//}
