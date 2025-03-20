//
//  FavouriteFilmsDataManager.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import Foundation
import CoreData

enum TableSections {
    case main
}

class FavouriteFilmsDataManager {
    
    private let coreData = CoreDataManager.shared

    func createNSFetchedResultController() -> NSFetchedResultsController<FavouriteFilmEntity> {
        coreData.createNSFetchedResultController()
    }
}
