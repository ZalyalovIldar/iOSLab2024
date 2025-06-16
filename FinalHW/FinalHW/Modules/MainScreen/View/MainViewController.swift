import UIKit
import Combine
import SwiftUI

// Главный экран
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var reminders: [Reminder] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscriptions()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        navigationItem.title = "Напоминания"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    private func setupSubscriptions() {
        ReminderService.shared.$reminders
            .sink { [weak self] reminders in
                self?.reminders = reminders
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func addTapped() {
        let createView = CreateReminderView()
        let hostingController = UIHostingController(rootView: createView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = "\(reminder.title) (каждые \(reminder.interval) мин)"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
        let detailView = ReminderDetailView(reminder: reminder)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
