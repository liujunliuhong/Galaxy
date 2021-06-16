//
//  BTCRequest.swift
//  Galaxy
//
//  Created by liujun on 2021/6/16.
//

import Foundation
import Alamofire
import SwiftyJSON

/// https://www.blockchain.com/api/blockchain_api
private let BTCBlockChainURL: String = "https://blockchain.info"


public struct BTCRequest {
    /// 获取`UTXO`
    public static func getUnspentTransactionOutputsWithAddresses(addresses: [String]) {
        let string = addresses.joined(separator: "%7C") // %7C -> |
        let url = BTCBlockChainURL + "/unspent" + "?" + "active=\(string)"
        
        Alamofire.AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .success(let responseObject):
                print(responseObject)
                if let resultDic = responseObject as? [String: Any] {
                    //print(resultDic)
                } else {
                    let error = BTCError.msg(message: "Data format error")
                    print(error.localizedDescription)
                }
            case .failure(let er):
                let error = BTCError.msg(message: er.localizedDescription)
                print(error.localizedDescription)
            }
        }
        /*
         {
             notice = "";
             "unspent_outputs" =     (
                         {
                     confirmations = 166439;
                     script = 76a9147ab89f9fae3f8043dcee5f7b5467a0f0a6e2f7e188ac;
                     "tx_hash" = b736d911f020d04e10f7968bf9a917e999daba36c8a077a206fe2f14a89c43d7;
                     "tx_hash_big_endian" = d7439ca8142ffe06a277a0c836bada99e917a9f98b96f7104ed020f011d936b7;
                     "tx_index" = 6446278334350362;
                     "tx_output_n" = 2;
                     value = 155228;
                     "value_hex" = 025e5c;
                 },
                         {
                     confirmations = 315392;
                     script = 76a9147ab89f9fae3f8043dcee5f7b5467a0f0a6e2f7e188ac;
                     "tx_hash" = 485259965fd88e550a8a0773ffa700a903ea96e9ede13b331fa3fa0cbedf71de;
                     "tx_hash_big_endian" = de71dfbe0cfaa31f333be1ede996ea03a900a7ff73078a0a558ed85f96595248;
                     "tx_index" = 2544592881449745;
                     "tx_output_n" = 154;
                     value = 10000;
                     "value_hex" = 2710;
                 }
             );
         }
         */
    }
}
