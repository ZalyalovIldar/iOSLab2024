//
//  TableViewDataSource.swift
//  SwiftPM
//
//  Created by Damir Rakhmatullin on 22.03.25.
//

import UIKit

class TableViewDataSource: NSObject {
    private var dataSource: UITableViewDiffableDataSource<TableViewSection, Tweet>?
    
    init(tableView: UITableView) {
        super.init()
        setupDataSource(tableView: tableView)
    }
    
    private func setupDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, tweet in
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseIdentifier, for: indexPath) as! TweetTableViewCell
            cell.configureCell(tweet: tweet)
            return cell
        })
    }
    
    public func applySnapshot(data: [Tweet]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Tweet>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot)
    }
    
    
    
}
