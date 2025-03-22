//
//  ViewController.swift
//  TestSPM
//
//  Created by дилара  on 22.03.2025.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }


    private func fetchData() {
        let url = "https://jsonplaceholder.typicode.com/comments?postId=1"

        AF.request(url).responseData { response in
            
            let json = JSON(response.data!)

            let jsonString = json.rawString()

            DispatchQueue.main.async {
                self.label.text = jsonString
            }
        }
    }
}
