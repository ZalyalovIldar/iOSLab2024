//
//  FilmImageSlideView.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 07.01.2025.
//

import UIKit

protocol FilmImageSlideViewDelegate: AnyObject {
    func next()
    func prev()
}

class FilmImageSlideView: UIView {

    private weak var delegate: FilmImageSlideViewDelegate?

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var forvardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray6
        button.transform = CGAffineTransform(scaleX: 2, y: 2)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.next()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray6
        button.transform = CGAffineTransform(scaleX: 2, y: 2)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.prev()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var upperDismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var lowerDismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemGray6
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    func setDelegate(delegate: FilmImageSlideViewDelegate) {
        self.delegate = delegate
    }
    
    func setDismissAction(dismiss: UIAction) {
        lowerDismissButton.addAction(dismiss, for: .touchUpInside)
        upperDismissButton.addAction(dismiss, for: .touchUpInside)
    }
    
    func deactivateBackwardButton() {
        backwardButton.alpha = 0.25
        backwardButton.isUserInteractionEnabled = false
    }
    
    func deactivateForwardButton() {
        forvardButton.alpha = 0.25
        forvardButton.isUserInteractionEnabled = false
    }
    
    func setupWithImage(imageTitle: String) {
        loadingIndicator.startAnimating()
        Task {
            do {
                image.image = try await ImageService.downloadImage(from: imageTitle)
                loadingIndicator.stopAnimating()
            } catch {
                print("Erorr of downloading image: \(error.localizedDescription)")
                image.image = .failToLoad
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = Colors.mainGray.withAlphaComponent(0.9)
        addSubview(upperDismissButton)
        addSubview(image)
        addSubview(forvardButton)
        addSubview(backwardButton)
        addSubview(loadingIndicator)
        addSubview(lowerDismissButton)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            image.widthAnchor.constraint(equalTo: self.widthAnchor),
            image.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.8),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            forvardButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -Constants.tiny),
            forvardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            backwardButton.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: Constants.tiny),
            backwardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            upperDismissButton.topAnchor.constraint(equalTo: self.topAnchor),
            upperDismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            upperDismissButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            upperDismissButton.bottomAnchor.constraint(equalTo: image.topAnchor),
            
            lowerDismissButton.topAnchor.constraint(equalTo: image.bottomAnchor),
            lowerDismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lowerDismissButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lowerDismissButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
