//
//  SafariVideoView.swift
//  Movies
//
//  Created by Павел Калинин on 25.12.2024.
//


import UIKit
import SafariServices

class SafariVideoView: UIView {
    
    // URL видео
    var videoURLString: String? {
        didSet {
            openVideoButton.isHidden = (videoURLString == nil)
        }
    }
    
    // Кнопка для открытия видео
    private let openVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Смотреть Видео", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(openVideoButton)
        
        // Центрируем кнопку внутри вью
        NSLayoutConstraint.activate([
            openVideoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            openVideoButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Добавляем действие для кнопки
        openVideoButton.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
        openVideoButton.isHidden = true // Скрываем кнопку, пока нет URL
    }
    
    // Действие для открытия видео
    @objc func openVideo() {
        guard let videoURLString = videoURLString, let videoURL = URL(string: videoURLString) else {
            return
        }
        
        // Получаем top-most view controller
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        let safariVC = SFSafariViewController(url: videoURL)
        safariVC.delegate = self
        topViewController.present(safariVC, animated: true, completion: nil)
    }
}

// Расширение для обработки событий SafariViewController (опционально)
extension SafariVideoView: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
}
