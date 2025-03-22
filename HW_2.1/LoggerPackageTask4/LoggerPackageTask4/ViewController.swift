//
//  ViewController.swift
//  LoggerPackageTask4
//
//  Created by Anna on 22.03.2025.
//

import UIKit
import LoggerPackage

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = "Это тестовое приложение"
        label.sizeToFit()
        label.frame.origin = .init(x: view.center.x - (label.frame.width / 2), y: view.center.y)
        view.addSubview(label)
        
        
        // тестовые логи
        Logger.log("Экран загружен", level: .info)
        Logger.log("Это предупреждение", level: .warning)
        Logger.log("Это ошибка", level: .error)
        
        // логирование ошибки
        do {
            throw NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
        } catch {
            Logger.logError(error)
        }
    }
}
