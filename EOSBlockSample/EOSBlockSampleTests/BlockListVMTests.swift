//
//  BlockListVMTests.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/8/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest
import EosioSwift
@testable import EOSBlockSample

class BlockListVMTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Tests that the default 20 blocks are loaded when the reload button is pressed.
    func testSuccess() {
        let provider = MockSuccessRpcApiProvider()
        let blockListVM = BlockListVM(provider: provider)
        let expectation = XCTestExpectation(description: "Block list loading complete with successful load.")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(blockListVM.loadedBlocks.count, 20)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    /// Tests if the info request fails and load completes with a getInfoError error.
    func testInfoFailure() {
        let provider = MockInfoFailRpcApiProvider()
        let blockListVM = BlockListVM(provider: provider)
        let expectation = XCTestExpectation(description: "Block list loading complete with getInfoError.")
        
        blockListVM.loadingCompletionBlock = { (error) in
            let eosioError = error! as! EosioError
            XCTAssertEqual(eosioError.errorCode, EosioErrorCode.getInfoError)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    /// Tests if the block request fails and load completes with a getBlockError error.
    func testBlockFailure() {
        let provider = MockBlockFailRpcApiProvider()
        let blockListVM = BlockListVM(provider: provider)
        let expectation = XCTestExpectation(description: "Block list loading complete with getInfoError.")
        
        blockListVM.loadingCompletionBlock = { (error) in
            let eosioError = error! as! EosioError
            XCTAssertEqual(eosioError.errorCode, EosioErrorCode.getBlockError)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testOneBlockReturnedSuccess() {
        let provider = MockOneBlockReturnedRpcApiProvider()
        let blockListVM = BlockListVM(provider: provider)
        let expectation = XCTestExpectation(description: "Block list loading complete with only 1 block.")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(blockListVM.loadedBlocks.count, 1)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
}
