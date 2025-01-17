//
//  FavouriteDataManager.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 15.01.25.
//

import CoreData

class FavouriteDataManager {
    
    private let coreData = CoreDataManager.shared
    
    func createFetchedResultController() -> NSFetchedResultsController<FavouriteFilmEntity> {
        coreData.createNSFetchedResultController()
    }
    
    func obtainFavouriteFilms() -> [FavouriteFilm] {
        coreData.obtainFavouriteFilms()
    }
}
