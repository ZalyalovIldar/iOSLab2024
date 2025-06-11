//
//  ViewController.swift
//  HW_2.1_SPM
//
//  Created by Павел Калинин on 17.03.2025.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        Task {
            label.text = try await getData()
        }
    }
    
    func setupLayout() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func getData() async throws -> String{
        guard let url = URL(string: "https://kudago.com/public-api/v1.2/locations/?lang=ru") else { return ""}
        
        let response = try await URLSession.shared.data(from: url)
        let json = try JSON(data: response.0)
        
        if let cityName = json[0]["name"].string {
            return cityName
        }
        return ""
    }
}

