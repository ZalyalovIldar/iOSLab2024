//
//  FavoriteModelData.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 14.01.2025.
//

import Foundation
import CoreData

class FavoriteModelData {
    private var coreDataManager = CoreDataManager.shared
    var fetchResultController: NSFetchedResultsController<MovieEntity>
    
    init() {
        fetchResultController = coreDataManager.createFetchResultController()
        do {
            try fetchResultController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
