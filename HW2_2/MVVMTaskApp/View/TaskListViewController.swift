import UIKit

class TaskListViewController: UITableViewController, TaskListViewModelDelegate {
    private let viewModel = TaskListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        viewModel.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped))
    }

    @objc private func addTapped() {
        let alert = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { _ in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                self.viewModel.addTask(title: title)
                self.tableView.reloadData()
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - TaskListViewModelDelegate
    func tasksDidUpdate() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tasks.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = viewModel.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = task.title
        cell.contentConfiguration = config
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        viewModel.toggleTask(task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}