//
//  RestaurantsNYTests.swift
//  RestaurantsNYTests
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import XCTest
@testable import RestaurantsNY

class RestaurantsNYTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInternet() {
        if Reachability.isConnectedToNetwork() == true {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
