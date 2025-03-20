//
//  ViewController.swift
//  CocoaPods
//
//  Created by Терёхин Иван on 18.03.2025.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.getCities { result in
            switch result {
            case .success(let cityResult):
                let city = cityResult
                print(city)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

