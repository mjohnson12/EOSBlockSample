//
//  BlockListVM.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation

protocol BlockListVMContract: class {
    var loadedBlocks: [EOSIOGetBlockDataAndResponse] { get }
    var loadingCompletionBlock:((Error?) -> Void)? { get set }
    func reloadButtonPressed()
}

final class BlockListVM: BlockListVMContract {
    enum BlockListVMError: Error, CustomStringConvertible {
        case strongSelfFailure
        
        var description: String {
            switch self {
            case .strongSelfFailure:
                return "Failed to obtain a reference to self"
            }
        }
    }
    
    private let providerType: EOSIORpcApiProviderContract.Type
    var loadingCompletionBlock:((Error?) -> Void)?
    
    init(providerType: EOSIORpcApiProviderContract.Type){
        self.providerType = providerType
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
            self.providerType.getInfo(timeout: 5) { [weak self] (info, error) in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(nil, BlockListVMError.strongSelfFailure)
                    }
                    return
                }
                
                if let info = info {
                    print("Info retrieved.  Blockid = \(info.head_block_id)")
                    // Get the head block.
                    self.getBlock(blockID: info.head_block_id, maxCount: maxCount, blocks: [], completion: completion)
                } else {
                    // Failed to get a valid info object so end by calling completion.
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    private func getBlock(blockID: String, maxCount: UInt, blocks: [EOSIOGetBlockDataAndResponse], completion: @escaping ([EOSIOGetBlockDataAndResponse]?, Error?) -> ()) {
        var blocks = blocks
        let request = EOSIOGetBlockRequest(block_num_or_id: blockID)
        // Get the block by blockID.
        self.providerType.getBlock(blockRequest: request, timeout: 5){ [weak self] (block, error) in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, BlockListVMError.strongSelfFailure)
                }
                return
            }
            
            if let block = block {
                blocks.append(block)
                print("Block: \(blocks.count) Previous: \(block.1.previous)")
                if blocks.count == maxCount {
                    // maxCount has been hit, trigger completion.
                    DispatchQueue.main.async {
                        completion(blocks, nil)
                    }
                } else {
                    // maxCount has not been hit so fetch the previous block by id.
                    self.getBlock(blockID: block.1.previous, maxCount: maxCount, blocks: blocks, completion: completion)
                }
            } else {
                if let error = error {
                    print("Error: \(error)")
                }
                // Failed to get a valid block so end by calling completion.
                DispatchQueue.main.async {
                    completion(blocks, error)
                }
            }
        }
    }
}
