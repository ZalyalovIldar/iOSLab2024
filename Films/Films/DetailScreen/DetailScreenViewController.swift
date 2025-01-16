//
//  DetailScreenViewViewController.swift
//  Films
//
//  Created by Артур Мавликаев on 10.01.2025.
//

import UIKit
import SafariServices


final class DetailScreenViewController: UIViewController, UITableViewDelegate, SFSafariViewControllerDelegate {
    private var FavoriteManeger = DataManager.shared
    var saveButton: UIBarButtonItem!
    private lazy var buttonStyle: () -> UIImage? = { [weak self] in
        guard let self = self else { return nil }
        return self.FavoriteManeger.films.contains(self.filmID) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }

    private func setupNavigationBar() {
        saveButton = UIBarButtonItem(image: buttonStyle(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        
        
        saveButton.tintColor = .white
        navigationItem .rightBarButtonItem = saveButton
    }
    @objc private func saveButtonTapped() {
        if FavoriteManeger.films.contains(filmID){
            FavoriteManeger.deleteFilm(fildId: filmID)
            
        }
        else{
            FavoriteManeger.saveFilm(filmId: filmID)        }
        saveButton.image = buttonStyle()
        print(UserDefaults.standard.value(forKey: "films") as? [Int])
    }
    private let filmID: Int
    private let detailView = DetailScreenView()
    private var dataSource: UITableViewDiffableDataSource<Int, DetailRow>!

    init(filmID: Int) {
        self.filmID = filmID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        saveButton.image = buttonStyle()
        fetchFilmDetails()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Детали фильма"
        view = detailView
        configureDataSource()
        detailView.tableView.delegate = self
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingIndicator()
    }
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private func showLoadingIndicator() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, DetailRow>(tableView: detailView.tableView) {
            tableView, indexPath, row in
            
            switch row {
            case .genres(let genresArray):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TextCell.identifier,
                    for: indexPath
                ) as? TextCell else {
                    return UITableViewCell()
                }
                cell.configureCycle(strings: genresArray, font: UIFont(name: "Times New Roman", size: 20) ?? UIFont.systemFont(ofSize: 20))
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
                
            case .stars(let starsArray):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TextCell.identifier,
                    for: indexPath
                ) as? TextCell else {
                    return UITableViewCell()
                }
                cell.configureCycle(strings: starsArray, font: UIFont(name: "Times New Roman", size: 20) ?? UIFont.systemFont(ofSize: 20))
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
                
            case .title(let titleString):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TextCell.identifier,
                    for: indexPath
                ) as? TextCell else {
                    return UITableViewCell()
                }
                cell.configure(text: titleString, font: UIFont.boldSystemFont(ofSize: 24))
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
                
            case .trailer(let trailerText):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TrailerButtonCell.identifier, for: indexPath
                ) as? TrailerButtonCell else {
                    return UITableViewCell()
                }
                if trailerText == "Трейлер отсутствует" {
                    cell.trailerButton.isEnabled = false
                    cell.trailerButton.alpha = 0.5
                } else {
                    cell.trailerButton.isEnabled = true
                    cell.trailerButton.alpha = 1.0
                }
                cell.onTrailerButtonTap = { [weak self] in
                    guard let self = self, let url = URL(string: trailerText) else { return }
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.delegate = self
                    safariVC.preferredControlTintColor = .white
                    safariVC.preferredBarTintColor = UIColor(
                        red: 36/255,
                        green: 42/255,
                        blue: 50/255,
                        alpha: 1
                    )
                    self.present(safariVC, animated: true)
                }
                cell.backgroundColor = UIColor(
                    red: 36/255,
                    green: 42/255,
                    blue: 50/255,
                    alpha: 1
                )
                cell.selectionStyle = .none
                return cell
            case .imdbRating(let text),
                    .runningTime(let text):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TextCell.identifier, for: indexPath
                ) as? TextCell else {
                    return UITableViewCell()
                }
                cell.configure(text: text, font: UIFont(name: "Times New Roman", size: 20) ?? UIFont.systemFont(ofSize: 20))
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(
                    red: 36/255,
                    green: 42/255,
                    blue: 50/255,
                    alpha: 1
                )
                return cell
            case .poster(let imageUrl):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PosterCell.identifier, for: indexPath
                ) as? PosterCell else {
                    return UITableViewCell()
                }
                cell.configure(with: imageUrl)
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(
                    red: 36/255,
                    green: 42/255,
                    blue: 50/255,
                    alpha: 1
                )
                return cell
            case .description(let text):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TextCell.identifier,
                    for: indexPath
                ) as? TextCell else {
                    return UITableViewCell()
                }
                cell.configure(text: text, font: UIFont(name: "Times New Roman", size: 20) ?? UIFont.systemFont(ofSize: 20))
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(
                    red: 36/255,
                    green: 42/255,
                    blue: 50/255,
                    alpha: 1
                )
                return cell
            }
        }}

    private func applySnapshot(with rows: [DetailRow]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailRow>()
        snapshot.appendSections([0])
        snapshot.appendItems(rows, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    private func animateRows(_ rows: [DetailRow]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailRow>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
        for (index, row) in rows.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 * Double(index)) {
                var currentSnapshot = self.dataSource.snapshot()
                if currentSnapshot.indexOfSection(0) == nil {
                    currentSnapshot.appendSections([0])
                }
                currentSnapshot.appendItems([row], toSection: 0)
                self.dataSource.apply(currentSnapshot, animatingDifferences: false)
            }
        }
    }

    
    private func fetchFilmDetails() {
        FilmsRepository.shared.fetchFilmDetails(filmID: filmID) { [weak self] result in
            DispatchQueue.main.async {
                        self?.hideLoadingIndicator()
                    }
            switch result {
            case .success(let filmDetail):
                DispatchQueue.main.async {
                    let rows = DetailDataBuilder.buildRows(from: filmDetail)
                    self?.animateRows(rows)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
