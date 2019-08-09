//
//  BlockDetailViewController.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import UIKit

final class BlockDetailViewController: UIViewController {
    @IBOutlet private var producerLabel: UILabel!
    @IBOutlet private var transactionsCountLabel: UILabel!
    @IBOutlet private var producerSignatureLabel: UILabel!
    @IBOutlet private var toggleJSONButton: UIButton!
    @IBOutlet private var jsonTextView: UITextView!
    
    private let viewModel: BlockDetailVMContract
    init(viewModel: BlockDetailVMContract) {
        self.viewModel = viewModel
        super.init(nibName: "BlockDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "Block Detail"
        // Set the controls to the values in the view model.
        producerLabel.text = viewModel.producer
        transactionsCountLabel.text = viewModel.transactionCount
        producerSignatureLabel.text = viewModel.producerSignature
        jsonTextView.isScrollEnabled = false
        jsonTextView.text = viewModel.blockJSON
        
        // Add handler for toggle JSON button.
        toggleJSONButton.addTarget(self, action: #selector(toggleJSONButtonPressed), for: .touchUpInside)
    }
    
    @objc func toggleJSONButtonPressed() {
        let isHidden = !jsonTextView.isHidden
        // Update the title of the toggle button.
        toggleJSONButton.setTitle(isHidden ? "Show JSON" : "Hide JSON", for: .normal)
        // Show/Hide the text view.
        jsonTextView.isHidden = isHidden
        jsonTextView.isScrollEnabled = !isHidden
    }
}
