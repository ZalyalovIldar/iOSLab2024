import UIKit

class MovieDetailDataManager {
    
    private let userDefaults = UserDefaults.standard
    private let favouriteKey = "is_favourite_"
    private let coreDataManager = CoreDataManager.shared
    
    func isBookmarked(movieTitle: String) -> Bool {
        userDefaults.bool(forKey: favouriteKey + movieTitle)
    }
    
    func getMovieImages(_ movie: MovieWithInfo) -> [String] {
        movie.images.map { $0.image }
    }

    func getTrailerLink(_ movie: MovieWithInfo) -> String {
        movie.trailerLink ?? ""
    }
    
    func getBookmarkButtonImage(for movie: MovieWithInfo) -> UIImage {
        isBookmarked(movieTitle: movie.title) ? .bookmarkDone : .bookmark
    }
    
    func switchMovieState(movie: MovieWithInfo) {
        let movie = mapToBookmarkedMovie(movie)
        
        let movieUniqueKey = favouriteKey + movie.title
        var updatedValue = userDefaults.bool(forKey: movieUniqueKey)
        
        updatedValue.toggle()
        userDefaults.set(updatedValue, forKey: movieUniqueKey)
        
        if isBookmarked(movieTitle: movie.title) {
            bookmarkMovie(movie)
        } else {
            deleteFilmFromFavourite(movie)
        }
    }
    
    private func bookmarkMovie(_ movie: BookmarkedMovie) {
        coreDataManager.saveBookmarkedMovie(movie)
    }
    
    private func deleteFilmFromFavourite(_ movie: BookmarkedMovie) {
        coreDataManager.removeBookmarkedMovie(movie)
    }
    
    private func mapToBookmarkedMovie(_ movie: MovieWithInfo) -> BookmarkedMovie {
        BookmarkedMovie(poster: Poster(image: movie.poster.image),
                                          title: movie.title,
                                          rating: movie.rating ?? 0.0,
                                          year: Int16(movie.year),
                                          runningTime: Int16(movie.runningTime ?? 0),
                                          country: movie.country)
    }
}
