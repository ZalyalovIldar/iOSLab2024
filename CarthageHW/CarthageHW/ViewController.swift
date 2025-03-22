//
//  ViewController.swift
//  CarthageHW
//
//  Created by Павел on 22.03.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    var photos: [Cat] = []
    let networkService = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    private func setupDataSource() {
        Task {
            do {
                photos = try await networkService.obtainCats()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.catsTableView.reloadData()
                }
            }
            catch {
                print(error)
            }

        }
    }
    
    private lazy var catsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CatsTableViewCell.self, forCellReuseIdentifier: CatsTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private func setupUI() {
        view.addSubview(catsTableView)
        
        NSLayoutConstraint.activate([
            catsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            catsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatsTableViewCell.identifier, for: indexPath) as! CatsTableViewCell
        cell.configureCell(with: photos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(350)
    }
    


}

