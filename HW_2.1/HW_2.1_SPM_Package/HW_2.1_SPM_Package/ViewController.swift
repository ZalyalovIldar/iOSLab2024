//
//  ViewController.swift
//  HW_2.1_SPM_Package
//
//  Created by Павел Калинин on 17.03.2025.
//

import UIKit
import ErrorLogs

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest()
    }

    func getRequest() {
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"

        guard let url = URL(string: urlString) else {
            ErrorLogger.log("Invalid URL", level: .error)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                ErrorLogger.logError(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                ErrorLogger.log("Invalid HTTP response", level: .error)
                return
            }

            guard let data = data else {
                ErrorLogger.log("No data received", level: .error)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Success: \(json)")

                    if let title = json["title"] as? String {
                        print("Title: \(title)")
                    }
                }
            } catch {
                ErrorLogger.logError(error)
            }
        }

        task.resume()
    }
    
}

