import UIKit
import CoreData

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var fetchedResultsController: NSFetchedResultsController<MovieFavoriteEntites>
    var onMoviesDetail: ((Int64) -> Void)?
    
    init(fetchedResultsController: NSFetchedResultsController<MovieFavoriteEntites>) {
        self.fetchedResultsController = fetchedResultsController
        super.init()
    }
    
    func updateFetchedResultsController(_ newFetchedResultsController: NSFetchedResultsController<MovieFavoriteEntites>) {
        self.fetchedResultsController = newFetchedResultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteScreenTableViewCell.reuseIndentifier, for: indexPath) as! FavoriteScreenTableViewCell
        let favoriteMovie = fetchedResultsController.object(at: indexPath)
        cell.configure(movie: favoriteMovie)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = fetchedResultsController.object(at: indexPath).id
        onMoviesDetail?(movieId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.screenHeight / 4.75
    }
}
