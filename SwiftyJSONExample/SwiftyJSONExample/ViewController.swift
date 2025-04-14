//
//  ViewController.swift
//  SwiftyJSONExample
//
//  Created by Артур Мавликаев on 22.03.2025.
//

import UIKit
import SwiftyJSON

struct Movie {
    let id: Int
    let site_url: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://kudago.com/public-api/v1.4/movies/10/"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print((error))
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            do {
                let json = try JSON(data: data)
                
                let movie = Movie(
                    id: json["id"].intValue,
                    site_url: json["site_url"].stringValue
                )
                
                print("ID: \(movie.id)")
                print("Site URL: \(movie.site_url)")
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }
        
        task.resume()
    }
}
