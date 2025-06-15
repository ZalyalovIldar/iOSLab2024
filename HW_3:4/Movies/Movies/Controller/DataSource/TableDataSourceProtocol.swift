//
//  MainViewCollectionProtocol.swift
//  Movies
//
//  Created by Павел Калинин on 24.12.2024.
//
import UIKit

protocol TableDataSourceProtocol: UITableViewDataSource {
    associatedtype ItemType
    func getItemByIndex(_ index: Int) -> ItemType
    func getItems() -> [ItemType]
    func removeAll()
}
