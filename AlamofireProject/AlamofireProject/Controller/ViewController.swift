//
//  ViewController.swift
//  AlamofireProject
//
//  Created by Тагир Файрушин on 19.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var mainView: MainView {
        self.view as! MainView
    }
    
    private var viewModel: MainViewModel
    
    private lazy var changePhotoAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.viewModel.changeRandomData()
    }

    override func loadView() {
        self.view = MainView()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureButton()
        bindingUpdate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func bindingUpdate() {
        viewModel.updatingImage = { [weak self] data in
            guard let self else { return }
            mainView.changePhoto(image: UIImage(data: data) ?? UIImage(resource: .default))
        }
    }
    
    func configureButton() {
        DispatchQueue.main.async {
            self.mainView.changeButton.addAction(self.changePhotoAction, for: .touchUpInside)
        }
    }

}

