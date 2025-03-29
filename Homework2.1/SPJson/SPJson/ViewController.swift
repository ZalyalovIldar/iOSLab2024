import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let parString = "{\"name\":\"Аааааа\",\"age\":30,\"city\":\"Самара\"}"
        if let dataFromString = parString.data(using: .utf8) {
            do {
                let json = try JSON(data: dataFromString)
                let name = json["name"].stringValue
                let age = json["age"].intValue
                let city = json["city"].stringValue
                print("Name: \(name), Age: \(age), City: \(city)")
            } catch {
                print("Ошибка при парсинге JSON: \(error)")
            }
        } else {
            print("Ошибка при конвертации строки в Data")
        }
    }
}

