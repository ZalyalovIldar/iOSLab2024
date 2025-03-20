//
//  ViewModel.swift
//  SwiftyJSONProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import Foundation
import SwiftyJSON

class ViewModel {
    
    private var passengers: [Passenger] = [] {
        didSet {
            updateTableView?(passengers)
        }
    }
    
    var updateTableView: (([Passenger]) -> Void)?
    
    func parseJSON(_ path: String) {
        if let path = Bundle.main.path(forResource: path, ofType: "json") {

            var parsedPassengers: [Passenger] = []
            do {
                let data = try Data(contentsOf: URL(filePath: path))
                let json = try JSON(data: data)
                for passengerJSON in json.arrayValue {
                    let passenger = Passenger(id: passengerJSON["PassengerId"].intValue,
                                              survived: passengerJSON["Survived"].intValue,
                                              name: passengerJSON["Name"].stringValue,
                                              sex: passengerJSON["Sex"].stringValue,
                                              age: passengerJSON["Age"].intValue)
                    parsedPassengers.append(passenger)
                }
                self.passengers = parsedPassengers
                
            } catch {
                print("Parsing error: \(error)")
            }
        }
    }
}
