//
//  ViewController.swift
//  HW_2.1_CP
//
//  Created by Павел Калинин on 18.03.2025.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    func getData() {
        let url = "https://jsonplaceholder.typicode.com/todos/1"

            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")

                    if let json = value as? [String: Any] {
                        if let title = json["title"] as? String {
                            print("Title: \(title)")
                        }
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }

    }
}

