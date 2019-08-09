//
//  MockRpcApiProviders.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest
@testable import EOSBlockSample

final class MockSuccessRpcApiProvider: EOSIORpcApiProviderContract {
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ()) {
        let infoResponse = EOSIOGetInfoResponse(head_block_id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504")
        completion(.success(infoResponse))
    }
    
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ()) {
        let blockResponse = EOSIOGetBlockResponse(id: blockRequest.block_num_or_id, block_num: 72796774, previous: "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172", timestamp: "2019-08-07T15:56:37.000", producer: "eosflytomars", producer_signature: "SIG_K1_KB1zKYGx9QouvumarYVKM2Eqhu4MdA2cs5wRHusYpFRjbzWQ4hvbcSU8Tvxok1ELqC1iTmW7TaQNjAKquGnagehXRnSnch", transactions: [])
        completion(.success((Data(), blockResponse)))
    }
}

final class MockInfoFail400RpcApiProvider: EOSIORpcApiProviderContract {
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ()) {
        completion(.failure(EOSIORpcApiProvider.EOSIORpcApiProviderError.httpRequestFailed(400)))
    }
    
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ()) {
        // Should be unused.
        XCTFail()
    }
}

final class MockBlockFail400RpcApiProvider: EOSIORpcApiProviderContract {
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ()) {
        let infoResponse = EOSIOGetInfoResponse(head_block_id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504")
        completion(.success(infoResponse))
    }
    
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ()) {
        completion(.failure(EOSIORpcApiProvider.EOSIORpcApiProviderError.httpRequestFailed(400)))
    }
}

final class MockOneBlockReturnedRpcApiProvider: EOSIORpcApiProviderContract {
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ()) {
        let infoResponse = EOSIOGetInfoResponse(head_block_id: "04577db53d17cddc725f471f2e090cbac6cfc8ee10212802b5ec2a29c684f504")
        completion(.success(infoResponse))
    }
    
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ()) {
        if blockRequest.block_num_or_id == "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172" {
            completion(.failure(EOSIORpcApiProvider.EOSIORpcApiProviderError.noDataReturned))
        } else {
            let blockResponse = EOSIOGetBlockResponse(id: blockRequest.block_num_or_id, block_num: 72796774, previous: "0456ca65581504781ddc2b12001fa8938b1af0996497aebb26ea30f258edd172", timestamp: "2019-08-07T15:56:37.000", producer: "eosflytomars", producer_signature: "SIG_K1_KB1zKYGx9QouvumarYVKM2Eqhu4MdA2cs5wRHusYpFRjbzWQ4hvbcSU8Tvxok1ELqC1iTmW7TaQNjAKquGnagehXRnSnch", transactions: [])
            completion(.success((Data(), blockResponse)))
        }
    }
}
