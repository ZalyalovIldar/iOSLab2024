//
//  ViewController.swift
//  SwiftPackageManager
//
//  Created by Терёхин Иван on 18.03.2025.
//

import UIKit
import SwiftyJSON
import CustomLogger

struct Book: CustomStringConvertible {
    var description: String {
        return "Book(title: \"\(title)\", author: \"\(author)\", year: \(publishedYear), genre: \"\(genre)\", isbn: \"\(isbn)\", available: \(available), copies: \(copies))"
    }
    
    let title: String
    let author: String
    let publishedYear: Int
    let genre: String
    let isbn: String
    let available: Bool
    let copies: Int
}


class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(getData())
    }
    
    private func getData() -> [Book] {
        
        var books = [Book]()
        
        if let file = Bundle.main.path(forResource: "Json", ofType: "json") {
            
            //MARK: парсинг данных с json через либу SwiftyJSON
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: file), options: .mappedIfSafe)
                
                let jsonArray = try JSON(data: data).arrayValue
                
                for book in jsonArray {
                    if let title = book["title"].string,
                       let author = book["author"].string,
                       let publishedYear = book["publishedYear"].int,
                       let genre = book["genre"].string,
                       let isbn = book["isbn"].string,
                       let available = book["available"].bool,
                       let copies = book["copies"].int {
                        
                        let book = Book(title: title, author: author, publishedYear: publishedYear, genre: genre,
                                        isbn: isbn, available: available, copies: copies)
                        
                        books.append(book)

                    }
                }
            } catch {
                //MARK: Использование кастомного логирования
                MyCustomLogger.logError(error)
            }
        }
        return books
    }
}

