//
//  ViewController.swift
//  SwiftPMTask2
//
//  Created by Anna on 20.03.2025.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingJsonFromString()
        parcingJsonFromResources()
    }
    

    //считываем и парсим json из строки
    func parsingJsonFromString() {
        
        let jsonString = """
    {
        "name": "Anna Vasileva",
        "age": 19,
        "email": "anntvas@gmail.com"
    }
    """
        //берём data из строки
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                // парсим json c помощью SwiftyJSON
                let json = try JSON(data: jsonData)
                let name = json["name"].stringValue
                let age = json["age"].intValue
                let email = json["email"].stringValue
                
                print("Name: \(name)")
                print("Age: \(age)")
                print("Email: \(email)")
            } catch {
                print("Ошибка при парсинге: \(error)")
            }
        }
    }
    
    //читаем json файл из группы Resources
    func parcingJsonFromResources() {
        // получаем путь к файлу
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                // читаем файл как Data
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                // парсим json c помощью SwiftyJSON
                let json = try JSON(data: data)
                
                let name = json["name"].stringValue
                let age = json["age"].intValue
                let email = json["email"].stringValue
                
                print("Name: \(name)")
                print("Age: \(age)")
                print("Email: \(email)")
            } catch {
                print("Error reading or parsing JSON file: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
}




