import UIKit

class TaskViewController: UITableViewController {
    private let viewModel: TaskViewModel
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTaskCompletion(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func addTask() {
        let alert = UIAlertController(title: "Добавить задачу", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите название задачи"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { _ in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                self.viewModel.addTask(title: title)
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
}
