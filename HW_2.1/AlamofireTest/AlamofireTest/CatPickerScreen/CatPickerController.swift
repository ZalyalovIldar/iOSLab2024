//
//  CatPickerController.swift
//  AlamofireTest
//
//  Created by Данил Забинский on 19.03.2025.
//

import UIKit

final class CatPickerController: UIViewController {
    
    private var catPickerView: CatPickerView {
        view as! CatPickerView
    }
    private let viewModel: CatPickerViewModel
    
    override func loadView() {
        view = CatPickerView(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        viewModel.onSelectedHttpStatusUpdate = { [weak self] data in
            Task {
                self?.catPickerView.setUpdatedImage(data: data)
            }
        }
    }
    
    init(viewModel: CatPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
