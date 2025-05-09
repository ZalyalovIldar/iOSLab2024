//
//  DetailModelData.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 08.01.2025.
//

import Foundation

protocol DetailModelDataDelegate: AnyObject {
    func updateCollectionView()
}

class DetailModelData {
    private var itemsSegmentControl: [String] = ["О фильме","Актеры"]
    private var coreDataManager = CoreDataManager.shared
    private weak var delegate: DetailModelDataDelegate?
    private var networkManager = NetworkManager(sessionConfiguration: .default)
    var isFavorite: Bool = false
    
    init(delegate: DetailModelDataDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getDetailMovie(movieId: Int) async -> DetailMovie? {
        if let detailMovieFromCoreData = coreDataManager.getDetailMovie(movieId: movieId) {
            isFavorite = true
            Task {
                do {
                    if let additionally = try await networkManager.obtainAdditionallyDetailMovie(id: movieId) {
                        detailMovieFromCoreData.images = additionally.images
                        detailMovieFromCoreData.stars = additionally.stars
                        detailMovieFromCoreData.writer = additionally.writer
                        detailMovieFromCoreData.director = additionally.director
                        detailMovieFromCoreData.trailer = additionally.trailer
                        
                        DispatchQueue.main.async {
                            self.delegate?.updateCollectionView()
                        }
                    }
                } catch {
                    print("Error obtaining additional detail movie: \(error)")
                }
            }
            return detailMovieFromCoreData
        }

        do {
            let detailMovie = try await networkManager.obtainDetailMovie(id: movieId)
            return detailMovie
        } catch {
            print("Error obtain detail movie: \(error)")
            return nil
        }
    }
    
    func obtainItemsSegmentControl() -> [String] {
        return itemsSegmentControl
    }
    
    func addMovieToFavorite(detailMovie: DetailMovie) async {
        await coreDataManager.toggleFavoriteMovie(detailMovie: detailMovie)
    }
 
}
