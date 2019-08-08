//
//  MockRpcApiProviders.swift
//  EOSBlockSampleTests
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest
import EosioSwift
@testable import EOSBlockSample

final class MockSuccessRpcApiProvider: EosioRpcProviderProtocol {
    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        let response = EosioRpcInfoResponse(chainId: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906", headBlockNum: EosioUInt64.uint64(73013664), lastIrreversibleBlockNum: EosioUInt64.uint64(73013330), lastIrreversibleBlockId: "045a1852c16a2a62c3b9bc4f8f050aba156be871762cddeb0109a0fef32ad70f", headBlockId: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", headBlockTime: "2019-08-08T22:04:40.500")
        completion(.success(response))
    }
    
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        let response = EosioRpcBlockResponse(timestamp: "2019-08-08T22:04:40.500", producer: "eosflytomars", confirmed: 0, previous: "045a199f9586fac4db088ea2f44fa8007d88c7cafeaf6b115db21e67ce74f15b", transactionMroot: "245ee65c083f9be0ccb48147840958db13ac8c0eca872857e3a1c9b30f8344d8", actionMroot: "3c3ebe1aa06b6571bddabbb953d96cb7a2299cf55d3db90fe52926b75b824718", scheduleVersion: 1063, newProducers: nil, headerExtensions: [], producerSignature: "SIG_K1_KYZhLPT1J8AUAMYC9ucHXMjhsaCjZpFLmsZ61bJk51Coi7cBGoxa6H5EkZQbsswwvVWTQ3edAHzzVtPqUyXqY9MPsESqKb", transactions: [], blockExtensions: [], id: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", blockNum: EosioUInt64.uint64(73013664), refBlockPrefix: EosioUInt64.uint64(1412355421))
        completion(.success(response))
    }
    
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
}

final class MockInfoFailRpcApiProvider: EosioRpcProviderProtocol {
    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        completion(.failure(EosioError(.getInfoError, reason: "http response of 400")))
    }
    
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        // Should be unused.
        XCTFail()
    }
    
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
}

final class MockBlockFailRpcApiProvider: EosioRpcProviderProtocol {
    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        let response = EosioRpcInfoResponse(chainId: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906", headBlockNum: EosioUInt64.uint64(73013664), lastIrreversibleBlockNum: EosioUInt64.uint64(73013330), lastIrreversibleBlockId: "045a1852c16a2a62c3b9bc4f8f050aba156be871762cddeb0109a0fef32ad70f", headBlockId: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", headBlockTime: "2019-08-08T22:04:40.500")
        completion(.success(response))
    }
    
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        completion(.failure(EosioError(.getBlockError, reason: "http response of 400")))
    }
    
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
}

final class MockOneBlockReturnedRpcApiProvider: EosioRpcProviderProtocol {
    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        let response = EosioRpcInfoResponse(chainId: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906", headBlockNum: EosioUInt64.uint64(73013664), lastIrreversibleBlockNum: EosioUInt64.uint64(73013330), lastIrreversibleBlockId: "045a1852c16a2a62c3b9bc4f8f050aba156be871762cddeb0109a0fef32ad70f", headBlockId: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", headBlockTime: "2019-08-08T22:04:40.500")
        completion(.success(response))
    }
    
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        let response = EosioRpcBlockResponse(timestamp: "2019-08-08T22:04:40.500", producer: "eosflytomars", confirmed: 0, previous: "045a199f9586fac4db088ea2f44fa8007d88c7cafeaf6b115db21e67ce74f15b", transactionMroot: "245ee65c083f9be0ccb48147840958db13ac8c0eca872857e3a1c9b30f8344d8", actionMroot: "3c3ebe1aa06b6571bddabbb953d96cb7a2299cf55d3db90fe52926b75b824718", scheduleVersion: 1063, newProducers: nil, headerExtensions: [], producerSignature: "SIG_K1_KYZhLPT1J8AUAMYC9ucHXMjhsaCjZpFLmsZ61bJk51Coi7cBGoxa6H5EkZQbsswwvVWTQ3edAHzzVtPqUyXqY9MPsESqKb", transactions: [], blockExtensions: [], id: "045a19a07d7759485dd52e542710310588892cde294373eb87adc08cffa9e475", blockNum: EosioUInt64.uint64(1), refBlockPrefix: EosioUInt64.uint64(1))
        completion(.success(response))
    }
    
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
    
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        // Unused
    }
}
