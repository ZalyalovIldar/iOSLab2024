//
//  ViewController.swift
//  MyOwnGOATPackageHW
//
//  Created by Павел on 22.03.2025.
//

import UIKit
import LogErrors

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        printCustomErrors()
    }
    
    private func printCustomErrors() {
        LogErrors.logInfo("Приложение успешно запущено и работает!")
        LogErrors.logWarning("У вас есть проблема с констрейнтами!")
        LogErrors.logError(NSError(domain: "test", code: 404))
    }


}

