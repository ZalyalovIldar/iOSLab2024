//
//  ViewController.swift
//  CustomLogger
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit
import CustomLoggerPackage

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        let logger = Logger()
        logger.log(.error, predefined: .networkError)
        logger.log(.info, "Request was accepted!")
    }
}
