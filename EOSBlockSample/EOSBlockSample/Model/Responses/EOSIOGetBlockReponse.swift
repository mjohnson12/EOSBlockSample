//
//  EOSIOGetBlockReponse.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/6/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation

struct EOSIOGetBlockResponse: Decodable {
    
    struct TransactionReponse: Decodable {
        let status: String
    }
    
    let id: String
    let block_num: Int
    let previous: String
    let timestamp: String
    let producer: String
    let producer_signature: String
    let transactions: [TransactionReponse]
}
