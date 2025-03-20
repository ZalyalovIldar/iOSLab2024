//
//  ViewController.swift
//  LoggerProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import UIKit
import Logger

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(error: .networkError)
        Logger.log(message: "My Error")
    }
}

