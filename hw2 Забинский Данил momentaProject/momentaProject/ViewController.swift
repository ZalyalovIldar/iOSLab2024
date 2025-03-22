//
//  ViewController.swift
//  momentaProject
//
//  Created by Данил Забинский on 16.10.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    // MARK: Properties
    private enum TableSections: Int {
        case main
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.separatorStyle = .none
        table.register(MomentTableViewCell.self, forCellReuseIdentifier: MomentTableViewCell.identifier)
        return table
    }()
    
    private lazy var navigationBarView: UIView = {
        let customView = UIView()
        setupText()
        return customView
        
        func setupText() {
            let text = UILabel()
            text.font = .boldSystemFont(ofSize: 23)
            text.text = "Moment"
            text.translatesAutoresizingMaskIntoConstraints = false
            
            customView.addSubview(text)
            NSLayoutConstraint.activate([
                text.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
                text.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            ])
        }
    }()

    private var moments: [Moment] = []
    private var tableViewDataSource: UITableViewDiffableDataSource<TableSections, Moment>?
    
    // MARK: Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Private methods
    private func setup() {
        setupTableView()
        setupNavigationBar()
        setupMoments()
        setupDataSource()
    }
    
    // MARK: Setup TableView
    private func setupTableView() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // MARK: Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.titleView = navigationBarView
        let addMomentAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let createMomentController = CreateMomentViewController()
            let navigationControllerToCreateMomentController = UINavigationController(rootViewController: createMomentController)
            self.present(navigationControllerToCreateMomentController, animated: true)
            
            createMomentController.saveCreatedMomentClosure = { [weak self] moment in
                guard let self else { return }
                guard var snaphot = tableViewDataSource?.snapshot() else { return }
                snaphot.appendItems([moment])
                moments.append(moment)
                tableViewDataSource?.apply(snaphot, animatingDifferences: false)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addMomentAction)
    }
    
    // MARK: Setup Moment
    private func setupMoments() {
        let customMomests = [
            Moment(id: UUID(),
                   autorsAvatar: .avatar,
                   title: "Hiring for my first job!",
                   date: Date(),
                   description: "The company 🍎 was looking for a talented Junior iOS🧑‍🤝‍🧑 Developer to join their team. This role required someone who could🔧 contribute to the development📱, maintenance, and enhancement of T-Bank's iOS mobile application 💻. The ideal candidate 🤓🧠 should possess strong knowledge of Swift programming language ⛵, iOS development frameworks 🌆, and experience with version control systems such as Git 🐒.\n\nApplication Process 🚀✈️\nMy journey began with submitting an online application to T-Bank's career portal 🌐. The company received numerous applications from aspiring iOS developers 👨‍💻👩‍💻, but they were particularly impressed by my portfolio, which showcased several iOS projects 📊🖼️ I had developed independently.\n\nAfter initial screening 🔍, I was invited for a video interview with the hiring manager 🎤. During this session, we discussed my background 🧳, skills 💪, and experiences related to iOS development 🌐. My passion for creating intuitive and efficient mobile interfaces 🏠💡 resonated well with the interviewer 👨‍💻.",
                   photos: [
                    .tBank,
                    .happy,
                    .image,
                   ]),
            Moment(id: UUID(),
                   autorsAvatar: .avatar,
                   title: "Coding progress",
                   date: Date(),
                   description: "Today I successfully solved my 158th problem on LeetCode! More other, I've made based functional of my \"Moment\" app.",
                   photos: [
                    .leetCode1,
                    .leetCode2,
                    .leetCode3,
                    .leetCode4
                   ]),
            Moment(id: UUID(),
                   autorsAvatar: .avatar,
                   title: "First App!",
                   date: Date(),
                   description: nil,
                   photos: [
                    .firstApp1,
                    .firstApp2
                   ]),
            Moment(id: UUID(),
                   autorsAvatar: .avatar,
                   title: "My feelings",
                   date: Date(),
                   description: "I feel my self productive! 📊",
                   photos: nil),
            Moment(id: UUID(),
                   autorsAvatar: UIImage(named: "avatarImage")!,
                   title: "My firts Barspin trick!",
                   date: Date(),
                   description: "The barspin is a fundamental freestyle BMX trick that involves spinning \n the bike around its vertical axis while keeping both wheels on the ground. This trick is considered \n one of the most \n basic \n yet \nessential skills for BMX riders." ,
                   photos: [
                    .smith
                   ]),
            Moment(id: UUID(),
                   autorsAvatar: .avatar,
                   title: "Sunset",
                   date: Date(),
                   description: nil,
                   photos: [
                    .sunset1,
                    .sunset2
                   ])
        ]
        moments.append(contentsOf: customMomests)
    }
    
    // MARK: Diffable Data Source
    private func setupDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource(tableView: tableView,
        cellProvider: { tableView, indexPath, moment in
            let cell = tableView.dequeueReusableCell(withIdentifier: MomentTableViewCell.identifier, for: indexPath) as! MomentTableViewCell
            cell.setupWithMoment(moment: moment, delegate: self)
            cell.selectionStyle = .none
            return cell
        })
        confirmSnapshot(moments: moments, animation: false)
    }
    
    private func confirmSnapshot(moments: [Moment], animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSections, Moment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(moments)
        tableViewDataSource?.apply(snapshot, animatingDifferences: animation)
    }
    
    // MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let moment = tableViewDataSource?.itemIdentifier(for: indexPath) else { return }
        guard let indexOfCurrentMoment = moments.firstIndex(of: moment) else { return }

        showMomentDetailController(moment, indexOfCurrentMoment)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func showMomentDetailController(_ moment: Moment, _ indexOfCurrentMoment: Int) {
        let momentDescriprionViewController = MomentDetailViewController(with: moment, withIndex: indexOfCurrentMoment, delegate: self)
        navigationController?.pushViewController(momentDescriprionViewController, animated: true)
        
        momentDescriprionViewController.shareCreatedMomentIntoTableView = { [weak self] createdMoment, index in
            guard let self = self else { return }
            guard var snapshot = self.tableViewDataSource?.snapshot() else { return }
            let momentToDelete = self.moments[index]
            snapshot.deleteItems([momentToDelete])
            snapshot.appendItems([createdMoment])
            self.tableViewDataSource?.apply(snapshot, animatingDifferences: false)
            self.moments.remove(at: index)
            self.moments.append(createdMoment)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: Extension ViewController to conform MomentDetailVCDelegate
extension ViewController: MomentDetailVCDelegate {
    func deleteMoment(with moment: Moment) {
        guard var snapshot = tableViewDataSource?.snapshot() else { return }
        snapshot.deleteItems([moment])
        moments.removeAll { $0.id == moment.id }
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: Extension ViewController to conform DidTapOnImageInPhotosCollectionView
extension ViewController: DidTapOnImageInPhotosCollectionView {
    func tappedOnImage(_ image: UIImage) {
        let momentImageViewController = MomentPhotoViewController(withImage: image)
        momentImageViewController.modalTransitionStyle = .crossDissolve
        self.present(momentImageViewController, animated: true)
    }
}


