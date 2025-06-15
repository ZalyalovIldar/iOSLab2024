//
//  FavouriteFilmsTableViewDiffableDataSource.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import Foundation
import UIKit

class FavouriteFilmsTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var favFilms: [FavouriteFilm] = []
    
    init(withFavFilms: [FavouriteFilm]) {
        self.favFilms = withFavFilms
    }
    
    func updateData(films: [FavouriteFilm]) {
        self.favFilms = films
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteFilmsTableViewCell.identifier, for: indexPath) as! FavouriteFilmsTableViewCell
        
        let currentFilm = favFilms[indexPath.item]
        cell.setupWithFilm(currentFilm)
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
