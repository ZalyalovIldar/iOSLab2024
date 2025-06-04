//
//  Tweet.swift
//  SwiftPM
//
//  Created by Damir Rakhmatullin on 21.03.25.
//

import Foundation

struct Tweet: Hashable {
    
    init(userName: String, url: String, text: String, followersCount: Int) {
        self.userName = userName
        self.url = url
        self.text = text
        self.followersCount = followersCount
    }
    
    let userName: String
    let url: String
    let text: String
    let followersCount: Int
    
}
