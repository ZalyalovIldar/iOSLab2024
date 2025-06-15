//
//  Post.swift
//  homework2
//
//  Created by Ильнур Салахов on 21.10.2024.
//

import Foundation
import UIKit

struct Post:Hashable,Identifiable{
    let id:UUID = UUID()
    var text: String
    var date: Date
    var images: [UIImage?]
}


