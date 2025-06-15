//
//  Post.swift
//  hw_2
//
//  Created by Кирилл Титов on 21.11.2024.
//

import UIKit

struct Post: Hashable {
    var id: UUID = UUID()
    var date: Date
    var text: String?
    var images: [UIImage]
}

