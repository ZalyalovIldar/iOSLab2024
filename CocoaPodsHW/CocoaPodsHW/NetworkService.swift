//
//  NetworkService.swift
//  CocoaPodsHW
//
//  Created by Павел on 21.03.2025.
//

import Foundation
import Alamofire

struct UserResult: Decodable {
    let result: [User]
}

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
}


class NetworkService {

    static func obtainUsers() async -> [User] {
        do {
            let usersData = try await AF.request("https://jsonplaceholder.typicode.com/users", method: .get)
                .serializingDecodable([User].self)
                .value
            return usersData
        }
        catch {
            print("some error with obtaining \(error)")
            return []
        }
    }
}
