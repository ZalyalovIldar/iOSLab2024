//
//  ViewController.swift
//  CocoaPodTask1
//
//  Created by Anna on 22.03.2025.
//

import UIKit
import Alamofire
import UIKit


class ViewController: UIViewController {
    let myButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить HTTP запрос", for: .normal)
        button.backgroundColor = .blue // Цвет фона
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myButton)
        setLayout()
        myButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
    }
    func setLayout() {
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 200),
            myButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func buttonTapped() {
        var sURL: String!
        sURL = "https://httpbin.org/get"
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        var sampleRequest = URLRequest(url: URL(string: sURL)!)
        AF.request(sampleRequest).uploadProgress { progress in
        }.response(responseSerializer: serializer) {
            response in
            if(response.error == nil) {
                var responseString: String!
                
                responseString = ""
                if (response.data != nil) {
                    responseString = String(bytes: response.data!, encoding: .utf8)
                } else {
                    responseString = response.response?.description
                }
                print(responseString ?? "")
                print(response.response?.statusCode)
            }
        }
    }
    
}


