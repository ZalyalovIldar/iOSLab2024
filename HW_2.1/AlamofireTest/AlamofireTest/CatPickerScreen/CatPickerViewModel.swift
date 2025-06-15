//
//  CatPickerViewModel.swift
//  AlamofireTest
//
//  Created by Данил Забинский on 19.03.2025.
//

import UIKit
import Alamofire

final class CatPickerViewModel {
    
    var selectedHttpStatus: HTTPStatus = .continue {
        didSet {
            if oldValue != selectedHttpStatus {
                Task {
                    do {
                        let data = try await fetchImage(for: selectedHttpStatus)
                        self.onSelectedHttpStatusUpdate?(data)
                    } catch {
                        print("Failed due to loading data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    var onSelectedHttpStatusUpdate: ((Data) -> Void)?
    
    private var cache: NSCache<NSString, NSData> = .init()
    
    @MainActor
    func fetchImage(for status: HTTPStatus) async throws -> Data {
        let urlString = "https://http.cat/\(status.getCode)"
        if let data = cache.object(forKey: urlString as NSString) {
            return data as Data
        }
        let response = try await AF.request(urlString, method: .get).serializingData().value
        cache.setObject(response as NSData, forKey: urlString as NSString)
        return response
    }
}
