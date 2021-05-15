//
//  SwiftToolTests.swift
//  SwiftToolTests
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import XCTest

class SwiftToolTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testExample() throws {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            
            
        }
    }
    
    func test111() {
        let originString = "卡"
        let originData = originString.data(using: .utf8)!
        print("originData: \(originData as NSData)") // <68656c6c 6f>
//
//        let newData = originData.gl_toHexString.gl_toHexData
//        print("1")
        
        let bytes = originString.gl_toBytes
        print(bytes)
        let s = bytes?.gl_bytesToHexString
        print(s)
    }
    
    func testURL() {
        let urlString = "http://www.baidu.com"
        
//        var url = URL(string: urlString)
//
//        let queryParameters = url?.gl_queryParameters
//        let newURL = url?.gl_appendingQueryParameters(["location": "成都"])
//        let kURL = url?.gl_deletingAllPathComponents()
//        print("😄")
//        print("queryParameters: \(queryParameters)")
//        print("newURL: \(newURL)")
//        print("kURL: \(kURL)")
        print("😄")
        print(urlString.gl_toURL(schemeType: .https))
        
    }

}
