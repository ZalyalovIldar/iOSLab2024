//
//  ViewController.swift
//  TestCocoapods
//
//  Created by дилара  on 22.03.2025.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("https://jsonplaceholder.typicode.com/posts").response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    print(String(data: data, encoding: .utf8) ?? "No data")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
