//
//  BlockDetailVMTests.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/8/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation
import XCTest
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
        let getBlockResponse = EOSIOGetBlockResponse(id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504", block_num: 72796774, previous: "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172", timestamp: "2019-08-07T15:56:37.000", producer: "eosflytomars", producer_signature: "SIG_K1_KB1zKYGx9QouvumarYVKM2Eqhu4MdA2cs5wRHusYpFRjbzWQ4hvbcSU8Tvxok1ELqC1iTmW7TaQNjAKquGnagehXRnSnch", transactions: [])
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producer_signature)
        XCTAssertEqual(blockDetailVM.transactionCount, "0 transactions")
    }
    
    /// Tests if the transaction count text on the block detail vm is correct given one transaction in the get block response.
    func testOneTranscationSuccess() {
        let testJSON = "{\"block_num_or_id\":\"04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504\"}"
        let jsonData = testJSON.data(using: .utf8)!
        let getBlockResponse = EOSIOGetBlockResponse(id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504", block_num: 72796774, previous: "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172", timestamp: "2019-08-07T15:56:37.000", producer: "eosflytomars", producer_signature: "SIG_K1_KB1zKYGx9QouvumarYVKM2Eqhu4MdA2cs5wRHusYpFRjbzWQ4hvbcSU8Tvxok1ELqC1iTmW7TaQNjAKquGnagehXRnSnch", transactions: [EOSIOGetBlockResponse.TransactionReponse(status: "executed")])
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producer_signature)
        XCTAssertEqual(blockDetailVM.transactionCount, "1 transaction")
    }
    
    /// Tests if the transaction count text on the block detail vm is correct given two transactions in the get block response.
    func testTwoTranscationsSuccess() {
        let testJSON = "{\"block_num_or_id\":\"04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504\"}"
        let jsonData = testJSON.data(using: .utf8)!
        let getBlockResponse = EOSIOGetBlockResponse(id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504", block_num: 72796774, previous: "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172", timestamp: "2019-08-07T15:56:37.000", producer: "eosflytomars", producer_signature: "SIG_K1_KB1zKYGx9QouvumarYVKM2Eqhu4MdA2cs5wRHusYpFRjbzWQ4hvbcSU8Tvxok1ELqC1iTmW7TaQNjAKquGnagehXRnSnch", transactions: [EOSIOGetBlockResponse.TransactionReponse(status: "executed"), EOSIOGetBlockResponse.TransactionReponse(status: "executed")])
        let blockDetailVM = BlockDetailVM(blockDataAndResponse: (jsonData, getBlockResponse))
        
        XCTAssertEqual(blockDetailVM.blockJSON, testJSON)
        XCTAssertEqual(blockDetailVM.producer, getBlockResponse.producer)
        XCTAssertEqual(blockDetailVM.producerSignature, getBlockResponse.producer_signature)
        XCTAssertEqual(blockDetailVM.transactionCount, "2 transactions")
    }
}
