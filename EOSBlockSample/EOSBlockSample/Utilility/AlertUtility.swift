//
//  AlertUtility.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import UIKit

final class AlertUtility {
    static func showErrorMessage(message: String, viewController: UIViewController, completion: (() -> Void)? = nil, alertDismissed: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .cancel) { (action) in
            if let alertDismissed = alertDismissed {
                alertDismissed()
            }
        }
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: completion)
    }
}
