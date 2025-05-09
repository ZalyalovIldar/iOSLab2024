//
//  TableViewDelegate.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 14.01.2025.
//

import Foundation
import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {
    
    private weak var delegate: SelectedMovieDelegate?
    private var tableViewDataSource: TableViewDataSource?
    
    init(dataSource: TableViewDataSource? = nil, delegate: SelectedMovieDelegate? = nil) {
        self.delegate = delegate
        self.tableViewDataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        tableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { isFinished in
            guard isFinished else { return }
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            } completion: { isFinished in
                guard isFinished else { return }
                if let dataSource = self.tableViewDataSource?.dataSource,
                    let objectId = dataSource.itemIdentifier(for: indexPath) {
                    if let movie = try? CoreDataManager.shared.viewContext.existingObject(with: objectId) as? MovieEntity {
                        self.delegate?.pushDetailView(movieId: Int(movie.movieId))
                    }
                }
                tableView.isUserInteractionEnabled = true
            }
        }
        
    }
}
