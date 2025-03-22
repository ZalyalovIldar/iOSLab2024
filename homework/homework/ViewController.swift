//
//  ViewController.swift
//  homework
//
//  Created by Артур Мавликаев on 22.03.2025.
//

import UIKit

import Alamofire


struct Movie: Decodable {
    let id: Int
    let site_url: String
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://kudago.com/public-api/v1.4/movies/10/"
            
            AF.request(urlString).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let movie = try decoder.decode(Movie.self, from: data)
                        
                        print("Movie ID: \(movie.id)")
                        print("Site URL: \(movie.site_url)")
                        
                    } catch {
                        print("Ошибка парсинга: \(error)")
                    }
                case .failure(let error):
                    print("Ошибка запроса: \(error)")
                }
            }
    
        
    }


}

