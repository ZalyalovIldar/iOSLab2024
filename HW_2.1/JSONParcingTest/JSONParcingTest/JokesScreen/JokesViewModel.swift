//
//  JokesViewModel.swift
//  JSONParcingTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import Foundation
import SwiftyJSON

final class JokesViewModel {
    
    func loadJokes(fromPath path: String) -> [Joke] {
        guard let filePath = Bundle.main.path(forResource: path, ofType: "json") else { return [] }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let json = try JSON(data: data)
            
            var jokeData: [Joke] = []
            for joke in json["jokes"].arrayValue {
                jokeData.append(Joke(
                    question: joke["details"]["question"]["text"].stringValue,
                    answer: joke["details"]["answer"]["text"].stringValue,
                    rating: joke["details"]["rating"].intValue)
                )
            }
            return jokeData
        } catch {
            print("Error of reading data from file: \(error.localizedDescription)")
        }
        return []
    }
}


/*
 if let filePath = Bundle.main.path(forResource: path, ofType: "json") {
     do {
         let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
     } catch {
         print("Error from parcing json")
     }
 }
 */
