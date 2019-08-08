//
//  BlockDetailVMTests.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/8/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest
import EosioSwift
@testable import EOSBlockSample

class BlockDetailVMTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Tests if the block detail vm is correct given a particular get block response.
    func testSuccess() {
        let testJSON = "{\"block_num_or_id\":\"04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504\"}"
        let jsonData = testJSON.data(using: .utf8)!
        let getBlockResponse = EosioRpcBlockResponse(timestamp: "2019-08-08T22:04:40.500", producer: "eosflytomars", confirmed: 0, previous: "045a199f9586fac4db088ea2f44fa8007d88c7cafeaf6b115db21e67ce74f15b", transactionMroot: "245ee65c083f9be0ccb48147840958db13ac8c0eca872857e3a1c9b30f8344d8", actionMroot: "3c3ebe1aa06b6571bddabbb953d96cb7a2299cf55d3db90fe52926b75b824718", scheduleVersion: 1063, newProducers: nil, headerExtensions: [], producerSignature: "SIG_K1_KYZhLPT1J8AUAMYC9ucHXMjhsaCjZpFLmsZ61bJk51Coi7cBGoxa6H5EkZQbsswwvVWTQ3edAHzzVtPqUyXqY9MPsESqKb", transactions: [], blockExtensions: [], id: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", blockNum: EosioUInt64.uint64(73013664), refBlockPrefix: EosioUInt64.uint64(1412355421))
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producerSignature)
        XCTAssertEqual(blockDetailVM.transactionCount, "0 transactions")
    }
    
    
    /// Tests if the transaction count text on the block detail vm is correct given one transaction in the get block response.
    func testOneTranscationSuccess() {
        let testJSON = "{\"block_num_or_id\":\"04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504\"}"
        let jsonData = testJSON.data(using: .utf8)!
        let getBlockResponse = EosioRpcBlockResponse(timestamp: "2019-08-08T22:04:40.500", producer: "eosflytomars", confirmed: 0, previous: "045a199f9586fac4db088ea2f44fa8007d88c7cafeaf6b115db21e67ce74f15b", transactionMroot: "245ee65c083f9be0ccb48147840958db13ac8c0eca872857e3a1c9b30f8344d8", actionMroot: "3c3ebe1aa06b6571bddabbb953d96cb7a2299cf55d3db90fe52926b75b824718", scheduleVersion: 1063, newProducers: nil, headerExtensions: [], producerSignature: "SIG_K1_KYZhLPT1J8AUAMYC9ucHXMjhsaCjZpFLmsZ61bJk51Coi7cBGoxa6H5EkZQbsswwvVWTQ3edAHzzVtPqUyXqY9MPsESqKb", transactions: [1], blockExtensions: [], id: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", blockNum: EosioUInt64.uint64(73013664), refBlockPrefix: EosioUInt64.uint64(1412355421))
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producerSignature)
        XCTAssertEqual(blockDetailVM.transactionCount, "1 transaction")
    }
    
    /// Tests if the transaction count text on the block detail vm is correct given two transactions in the get block response.
    func testTwoTranscationsSuccess() {
        let testJSON = "{\"block_num_or_id\":\"04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504\"}"
        let jsonData = testJSON.data(using: .utf8)!
        let getBlockResponse = EosioRpcBlockResponse(timestamp: "2019-08-08T22:04:40.500", producer: "eosflytomars", confirmed: 0, previous: "045a199f9586fac4db088ea2f44fa8007d88c7cafeaf6b115db21e67ce74f15b", transactionMroot: "245ee65c083f9be0ccb48147840958db13ac8c0eca872857e3a1c9b30f8344d8", actionMroot: "3c3ebe1aa06b6571bddabbb953d96cb7a2299cf55d3db90fe52926b75b824718", scheduleVersion: 1063, newProducers: nil, headerExtensions: [], producerSignature: "SIG_K1_KYZhLPT1J8AUAMYC9ucHXMjhsaCjZpFLmsZ61bJk51Coi7cBGoxa6H5EkZQbsswwvVWTQ3edAHzzVtPqUyXqY9MPsESqKb", transactions: [1, 2], blockExtensions: [], id: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", blockNum: EosioUInt64.uint64(73013664), refBlockPrefix: EosioUInt64.uint64(1412355421))
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producerSignature)
        XCTAssertEqual(blockDetailVM.transactionCount, "2 transactions")
    }
}
