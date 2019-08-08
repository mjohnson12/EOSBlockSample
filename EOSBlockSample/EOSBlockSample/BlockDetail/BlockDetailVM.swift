//
//  BlockDetailVM.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation

protocol BlockDetailVMContract: class {
    var producer: String { get }
    var transactionCount: String { get }
    var producerSignature: String { get }
    var blockJSON: String? { get }
}

final class BlockDetailVM: BlockDetailVMContract {
    private let blockDataAndResponse: EOSIOGetBlockDataAndResponse
    
    var producer: String {
        return blockDataAndResponse.1.producer
    }
    var transactionCount: String {
        return "\(blockDataAndResponse.1.transactions.count) transaction" + (blockDataAndResponse.1.transactions.count == 1 ? "" : "s")
    }
    var producerSignature: String {
        return blockDataAndResponse.1.producer_signature
    }
    var blockJSON: String? {
        return String(data: blockDataAndResponse.0, encoding: String.Encoding.utf8)
    }
    
    init(blockDataAndResponse: EOSIOGetBlockDataAndResponse) {
        self.blockDataAndResponse = blockDataAndResponse
    }
}
