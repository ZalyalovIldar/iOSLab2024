//
//  CoreDataManager.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    func saveMovies(movies: [Movie]) {
        let context = PersistenceController.shared.container.viewContext
        
        for movie in movies.prefix(10) {
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.poster = movie.poster.image
            movieEntity.isFavorite = false
        }
        
        do {
            try context.save() 
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }

    
    func fetchMovies() -> [MovieEntity] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        return (try? context.fetch(fetchRequest)) ?? []
    }

    func toggleFavorite(movieEntity: MovieEntity) {
        movieEntity.isFavorite.toggle()
        try? PersistenceController.shared.container.viewContext.save()
    }
}
