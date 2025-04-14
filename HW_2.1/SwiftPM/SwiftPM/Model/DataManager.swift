//
//  DataManager.swift
//  SwiftPM
//
//  Created by Damir Rakhmatullin on 18.03.25.
//

import Foundation

import SwiftyJSON

class DataManager {
    func loadJson() -> [Tweet] {
        guard let file = Bundle.main.path(forResource: "SwiftyJSONTests", ofType: "json") else {return []}
        var tweets: [Tweet] = []
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: file))
            let json = try JSON(data: jsonData)
            
           
            for tweet in json.arrayValue {
                tweets.append(Tweet(
                    userName: tweet["user"]["name"].stringValue,
                    url: tweet["user"]["url"].stringValue,
                    text: tweet["text"].stringValue,
                    followersCount: tweet["user"]["followers_count"].intValue)
                )
            }
        } catch {
            print("failed to parse JSON")
        }
        return tweets
    }
}

