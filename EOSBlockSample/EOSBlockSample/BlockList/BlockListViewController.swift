//
//  BlockListViewController.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/6/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import UIKit
import EosioSwift

final class BlockListViewController: UIViewController {

    @IBOutlet private var blockTableView: UITableView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    private let viewModel: BlockListVMContract = BlockListVM(provider: EosioRpcProvider(endpoint: URL(string: "https://api.eosnewyork.io/v1")!))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "Blocks"
        // Set the datasource and delegate.
        blockTableView.dataSource = self
        blockTableView.delegate = self
        // Register the cell.
        blockTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultIdentifier")
        // Hide empty separator lines.
        blockTableView.tableFooterView = UIView()
        // Create reload button.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadButtonPressed))
        
        // Register for loading complete callback.
        viewModel.loadingCompletionBlock = { [weak self] (error) in
            guard let self = self else { return }
            // Turn off the activity indicator.
            self.activityView.stopAnimating()
            // Re-enable reload button.
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            if let error = error {
                // Handle or show error.
                AlertUtility.showErrorMessage(message: "Error: \(error)", viewController: self)
            }
            
            // Load the blocks into the table.
            self.blockTableView.reloadData()
        }
    }
    
    @objc func reloadButtonPressed() {
        // Disable the reload button while a reload is occurring.
        navigationItem.rightBarButtonItem?.isEnabled = false
        // Show the activity view animating while a reload is ocurring.
        activityView.startAnimating()
        
        viewModel.reloadButtonPressed()
    }
}

extension BlockListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.loadedBlocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultIdentifier", for: indexPath)
        
        let block = viewModel.loadedBlocks[indexPath.row]
        cell.textLabel?.text = "Block \(block.1.blockNum.value)"
        cell.textLabel?.accessibilityIdentifier = "row\(indexPath.row)"
        
        return cell
    }
}

extension BlockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let block = viewModel.loadedBlocks[indexPath.row]
        
        // Load the detail view for the selected block.
        let viewController = BlockDetailViewController(viewModel: BlockDetailVM(blockDataAndResponse: block))
        navigationController?.pushViewController(viewController, animated: true)
    }
}
