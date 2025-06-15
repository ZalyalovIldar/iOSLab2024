//
//  JokesTableViewDataSource.swift
//  JSONParcingTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit

final class JokesTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var data: [Joke]
    
    init(data: [Joke]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.identifier, for: indexPath) as! JokeCell
        cell.setupWithJoke(data[indexPath.row])
        let currentViewModel = JokesViewModel()
        cell.setViewModel(viewModel: currentViewModel)
        return cell
    }
}
