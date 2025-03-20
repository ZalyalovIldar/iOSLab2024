//
//  CatPickerView.swift
//  AlamofireTest
//
//  Created by Данил Забинский on 19.03.2025.
//

import UIKit

final class CatPickerView: UIView {
    
    private let pickerData = HTTPStatus.allCases
    private var viewModel: CatPickerViewModel
    
    private lazy var imagePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
        ])
        return picker
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let image = UIImageView(image: .imagePlaceholder)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
            image.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
        ])
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imagePickerView,
            selectedImageView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    init(viewModel: CatPickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor
    func setUpdatedImage(data: Data) {
        selectedImageView.image = UIImage(data: data)
    }
}

private extension CatPickerView {
    
    func setup() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(dataStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension CatPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedHttpStatus = pickerData[row]
    }
}
