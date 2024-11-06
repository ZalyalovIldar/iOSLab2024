//
//  Post.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 29.10.2024.
//


import UIKit

struct Post: Hashable, Equatable {
    let id: UUID
    let date: Date
    let text: String?
    let images: [UIImage]?
}
