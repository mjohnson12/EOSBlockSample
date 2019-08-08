//
//  BlockListVM.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation
import EosioSwift

typealias EOSIOGetBlockDataAndResponse = (Data, EosioRpcBlockResponse)

protocol BlockListVMContract: class {
    var loadedBlocks: [EOSIOGetBlockDataAndResponse] { get }
    var loadingCompletionBlock:((Error?) -> Void)? { get set }
    func reloadButtonPressed()
}

final class BlockListVM: BlockListVMContract {
    enum BlockListVMError: Error, CustomStringConvertible {
        case strongSelfFailure
        case blockResponseCastFailure
        
        var description: String {
            switch self {
            case .strongSelfFailure:
                return "Failed to obtain a reference to self"
            case .blockResponseCastFailure:
                return "The returned block response object is not of the type EosioRpcBlockResponse"
            }
        }
    }
    
    private let provider: EosioRpcProviderProtocol
    var loadingCompletionBlock:((Error?) -> Void)?
    
    init(provider: EosioRpcProviderProtocol){
        self.provider = provider
    }
    
    var loadedBlocks: [EOSIOGetBlockDataAndResponse] = []
    
    func reloadButtonPressed() {
        loadBlocks(completion: loadingCompletionBlock)
    }
    
    private func loadBlocks(maxCount: UInt = 20, completion: ((Error?) -> Void)?) {
        // Call to get a maxCount of blocks.
        getBlocks(maxCount: maxCount) { [weak self] (blocks, error) in
            guard let self = self else {
                completion?(BlockListVMError.strongSelfFailure)
                return
            }
            
            if let blocks = blocks {
                // Store the loaded blocks.
                self.loadedBlocks = blocks
            }
            
            completion?(error)
        }
    }
    
    private func getBlocks(maxCount: UInt, completion: @escaping ([EOSIOGetBlockDataAndResponse]?, Error?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            // Get the chain info to retrieve the head block.
            self.provider.getInfo(completion: { [weak self] (infoResponse) in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(nil, BlockListVMError.strongSelfFailure)
                    }
                    return
                }
                
                switch infoResponse {
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                case .success(let info):
                    print("Info retrieved.  BlockNum = \(info.headBlockNum.value)")
                    // Get the head block.
                    self.getBlock(blockNum: info.headBlockNum.value, maxCount: maxCount, blocks: [], completion: completion)
                }
            })
        }
    }
    
    private func getBlock(blockNum: UInt64, maxCount: UInt, blocks: [EOSIOGetBlockDataAndResponse], completion: @escaping ([EOSIOGetBlockDataAndResponse]?, Error?) -> ()) {
        var blocks = blocks
        let blockRequest = EosioRpcBlockRequest(blockNumOrId: blockNum)
        
        self.provider.getBlock(requestParameters: blockRequest) { (result) in
            switch result {
            case .success(let blockResponse):
                let data: Data
                
                // The detail view uses properties that are only available on the EosioRpcBlockResponse object not just the protocol.
                // Make sure the blockResponse is an EosioRpcBlockResponse object.
                guard let blockResponseObject = blockResponse as? EosioRpcBlockResponse else {
                    completion(nil, BlockListVMError.blockResponseCastFailure)
                    return
                }
                
                // Generate the JSON data.
                if let rawJsonData = blockResponseObject._rawResponse as? [String : Any] {
                    data = (try? JSONSerialization.data(withJSONObject: rawJsonData, options: .prettyPrinted)) ?? Data()
                } else {
                    data = Data()
                }
                
                print("Block retrieved.  BlockNum=\(blockResponse.blockNum.value)")
                // Store the retrieved block with accompaning JSON data.
                blocks.append((data, blockResponseObject))
                
                if blocks.count == maxCount {
                    // maxCount has been hit, trigger completion.
                    DispatchQueue.main.async {
                        completion(blocks, nil)
                    }
                } else {
                    let blockNumToGet = blockResponse.blockNum.value - 1
                    if blockNumToGet < 1 {
                        // Not a valid block num so end with what has been loaded.
                        DispatchQueue.main.async {
                            completion(blocks, nil)
                        }
                    } else {
                        // maxCount has not been hit so fetch the previous block by block num.
                        self.getBlock(blockNum: blockNumToGet, maxCount: maxCount, blocks: blocks, completion: completion)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(blocks, error)
                }
            }
        }
    }
}
