import Foundation
import UIKit

class BookmarkedMoviesTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var bookmarkedMovie: [BookmarkedMovie] = []
    
    init(withFavFilms: [BookmarkedMovie]) {
        self.bookmarkedMovie = withFavFilms
    }
    
    func updateData(movies: [BookmarkedMovie]) {
        self.bookmarkedMovie = movies
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkedMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkedMoviesTableViewCell.identifier, for: indexPath) as! BookmarkedMoviesTableViewCell
        
        let currentMovie = bookmarkedMovie[indexPath.item]
        cell.setupWithMovie(currentMovie)
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
