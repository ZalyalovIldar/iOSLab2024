import UIKit
import Combine

protocol ReminderListViewProtocol: AnyObject {
    func update(with reminders: [Reminder])
}

class ReminderListView: UIViewController, UITableViewDataSource, UITableViewDelegate, ReminderListViewProtocol {

    private let tableView = UITableView()
    private var reminders: [Reminder] = []
    var presenter: ReminderListPresenterProtocol!
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = ReminderListPresenter(view: self)
        presenter.loadReminders()
        subscribeToReminders()
    }

    @objc private func addButtonTapped() {
        presenter.showCreateScreen(from: self)
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = reminders[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(reminder: reminders[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func update(with reminders: [Reminder]) {
        self.reminders = reminders
        tableView.reloadData()
    }

    private func subscribeToReminders() {
        ReminderService.shared.$reminders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedReminders in
                self?.update(with: updatedReminders)
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

