//
//  ViewController.swift
//  SPM
//
//  Created by дилара  on 22.03.2025.
//

import UIKit
import MyLibrary

class ViewController: UIViewController {
    // Создаем кнопки для демонстрации логирования
    private let infoButton = UIButton(type: .system)
    private let warningButton = UIButton(type: .system)
    private let errorButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        infoButton.setTitle("Log Info", for: .normal)
        infoButton.backgroundColor = .systemBlue
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.addTarget(self, action: #selector(logInfo), for: .touchUpInside)

        warningButton.setTitle("Log Warning", for: .normal)
        warningButton.backgroundColor = .systemOrange
        warningButton.setTitleColor(.white, for: .normal)
        warningButton.addTarget(self, action: #selector(logWarning), for: .touchUpInside)

        errorButton.setTitle("Log Error", for: .normal)
        errorButton.backgroundColor = .systemRed
        errorButton.setTitleColor(.white, for: .normal)
        errorButton.addTarget(self, action: #selector(logError), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [infoButton, warningButton, errorButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func logInfo() {
        Logger.shared.info("This is an informational message from ViewController.")
    }

    @objc private func logWarning() {
        Logger.shared.warning("This is a warning message from ViewController.")
    }

    @objc private func logError() {
        Logger.shared.error("This is an error message from ViewController.")
    }
}
