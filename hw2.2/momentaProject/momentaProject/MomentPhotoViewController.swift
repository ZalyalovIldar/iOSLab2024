//
//  MomentPhotoViewController.swift
//  momentaProject
//
//  Created by Данил Забинский on 04.11.2024.
//

import UIKit

class MomentPhotoViewController: UIViewController {
    // MARK: Properties
    private struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
    
    private lazy var closeImageButton: UIButton = {
        let closeImageAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }
        let button = UIButton(primaryAction: closeImageAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var controllerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = currentImage
        return image
    }()
    
    private var currentImage: UIImage!

    // MARK: Init
    init(withImage image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        currentImage = image
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    private func setup() {
        setupLayout()
        setupNavigationBar()
    }
    
    private func setupLayout() {
        closeImageButton.addSubview(controllerImage)
        view.addSubview(closeImageButton)
        NSLayoutConstraint.activate([
            controllerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controllerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            closeImageButton.heightAnchor.constraint(equalToConstant: max(Constants.screenHeight, Constants.screenWidth)),
            closeImageButton.widthAnchor.constraint(equalToConstant: max(Constants.screenWidth, Constants.screenHeight)),
            
            controllerImage.heightAnchor.constraint(equalToConstant: min(Constants.screenWidth, Constants.screenHeight) * 0.9),
            controllerImage.widthAnchor.constraint(equalTo: controllerImage.heightAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
    }
}
