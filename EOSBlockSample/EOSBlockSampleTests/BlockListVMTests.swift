//
//  BlockListVMTests.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/8/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest
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
        let blockListVM = BlockListVM(providerType: MockSuccessRpcApiProvider.self)
        let expectation = XCTestExpectation(description: "Block list loading complete with successful load")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(blockListVM.loadedBlocks.count, 20)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    /// Tests if the info request fails with a 400 that the load completes with a http request failed 400 error.
    func testInfo400Failure() {
        let blockListVM = BlockListVM(providerType: MockInfoFail400RpcApiProvider.self)
        let expectation = XCTestExpectation(description: "Block list loading complete with http failure status code 400")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(error! as? EOSIORpcApiProvider.EOSIORpcApiProviderError, .httpRequestFailed(400))
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    /// Tests if the block request fails with a 400 that the load completes with a http request failed 400 error.
    func testBlock400Failure() {
        let blockListVM = BlockListVM(providerType: MockBlockFail400RpcApiProvider.self)
        let expectation = XCTestExpectation(description: "Block list loading complete with http failure status code 400")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(error! as? EOSIORpcApiProvider.EOSIORpcApiProviderError, .httpRequestFailed(400))
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
    
    /// Tests if only one block is returned from the provider is that what is in the loaded blocks after loading completes.
    func testOneBlockReturnedSuccess() {
        let blockListVM = BlockListVM(providerType: MockOneBlockReturnedRpcApiProvider.self)
        let expectation = XCTestExpectation(description: "Block list loading complete with only 1 block.")
        
        blockListVM.loadingCompletionBlock = { (error) in
            XCTAssertEqual(blockListVM.loadedBlocks.count, 1)
            expectation.fulfill()
        }
        
        blockListVM.reloadButtonPressed()
        wait(for: [expectation], timeout: 10.0)
    }
}
