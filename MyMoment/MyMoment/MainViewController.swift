//
//  MainViewController.swift
//  MyMoment
//
//  Created by Павел on 16.10.2024.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Types

    enum TableSection {
        case main
    }

    // MARK: - Properties

    private var posts: [Post] = [
        Post(
            id: UUID(),
            title: "Красивое",
            date: Date.distantPast,
            text: "",
            photos: [UIImage(named: "image4")!, UIImage(named: "image5")!, UIImage(named: "image6")!, UIImage(named: "image8")!]
        ),
        Post(
            id: UUID(),
            title: "Казань",
            date: Date.distantPast,
            text: "Просто красивые фоточки",
            photos: [UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!]
        ),
        Post(
            id: UUID(),
            title: "Apple закручивает гайки",
            date: Date.distantPast,
            text:"""
            💳 Вообще не проходят проверки приложений с покупками по ссылке. Саппорт игнорит всех (прим. кто был на консультации
            💳 Холдят выплаты с рф-аккаунтов. У кого-то всё в порядке, но жалоб стало больше чем обычно
            📊 Вырубили Apple Search Ads
            Много разговоров о пакете санкций 12 сентября, но без конкретики. Разберем возможные кейсы:
            Если запретят оплачивать новые аккаунты, то можно регать их в другом регионе. Если приложение большое — лучше открыть компанию, подойдут UK или Гонконг (дистанционно и дёшево)
            Если отзовут платные соглашения
            Сейчас они есть только у аккаунтов до 2022 года, если регистрировали недавно — у вас его и так нет. Если есть, лучше перенести приложения заранее
            Закроют учетки РФ-разработчиков
            Что делать зависит от того, как закроют. Если просто на паузу, то перенести приложение получится. Если отзовут соглашение — приложение зависнет на аккаунте
            Следить можно в нашем чате по 👨‍💻 App Store Connect. Если появится что-то важное, напишу здесь 
            """,
            photos: [UIImage(named: "image9")!]
        ),
        Post(
            id: UUID(),
            title: "Погуляли :)",
            date: Date.distantPast,
            text: "Это я с друзьями был, щас дома уже",
            photos: [UIImage(named: "image7")!]
        ),
    ]

    private lazy var addPost = UIAction { [weak self] _ in
        guard let self = self else { return }
        let createViewController = CreateViewController()
        createViewController.newPostClosure = { [weak self] newPost in
            self?.posts.append(newPost)
            self?.updateDataSource(with: self!.posts)
        }
        let navigationController = UINavigationController(rootViewController: createViewController)
        createViewController.modalPresentationStyle = .formSheet
        self.present(navigationController, animated: true)
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MomentTableViewCell.self, forCellReuseIdentifier: MomentTableViewCell.identifier)
        table.estimatedRowHeight = 300
        table.separatorColor = .clear
        table.backgroundColor = .systemGray6
        table.delegate = self
        return table
    }()

    private var dataSource: UITableViewDiffableDataSource<TableSection, Post>?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        setupUI()
        configureDataSource()
        setupNavigationBar()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.title = "Моменты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.and.list.clipboard"), primaryAction: addPost)
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, post in
            let cell = tableView.dequeueReusableCell(withIdentifier: MomentTableViewCell.identifier, for: indexPath)
            as! MomentTableViewCell
            cell.configureCell(with: post)
            return cell
        })
        updateDataSource(with: posts)
    }

    private func updateDataSource(with posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func setupUI() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = dataSource?.itemIdentifier(for: indexPath)

        let detailViewController = DetailViewController()
        detailViewController.post = post
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - DetailPostDelegate

extension MainViewController: DetailPostDelegate {
    func updatePost(post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts.remove(at: index)
            posts.insert(post, at: index)
            updateDataSource(with: posts)
        }
    }

    func deletePost(post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            guard var snapshot = dataSource?.snapshot() else { return }
            posts.remove(at: index)
            snapshot.deleteItems([post])
            dataSource?.apply(snapshot)
        }
    }
}
