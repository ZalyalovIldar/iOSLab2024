import UIKit

class ViewController: UIViewController {
    
    private var tasks: [TaskCellViewModel] = []
    private let storageService = StorageService<TaskItem>()
    private var viewModel: TaskViewModel<StorageService<TaskItem>>!
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel = TaskViewModel(storageService: storageService)
        
        setupTableView()
        setupNavigationBar()
        loadTasks()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Задачи"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    @objc private func addTask() {
        let alert = UIAlertController(title: "Новая задача", message: "Введите новую задачу", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Название задачи"
        }
        
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in guard let self = self,
                                                                                                       let textField = alert.textFields?.first,
                                                                                                       let taskTitle = textField.text,
                                                                                                       !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            let newTask = TaskItem(id: UUID(), title: taskTitle, isCompleted: false)
            self.viewModel.saveTask(newTask, forKey: newTask.id.uuidString)
            self.loadTasks()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: метод для мониторинга статуса задач в целях дебаггинга и проверки работоспособности обновлений
    private func printTasksStatus() {
        print("=== Текущий список задач ===")
        for taskVM in tasks {
            print("ID: \(taskVM.id.uuidString), Title: \"\(taskVM.title)\", isCompleted: \(taskVM.isCompleted)")
        }
        print("============================")
    }
    
    private func loadTasks() {
        let taskItems = viewModel.getAllTasks()
        
        var allTasks = taskItems
        
        if !allTasks.contains(where: { $0.title == "Задача по умолчанию" }) {
            let defaultTask = TaskItem(id: UUID(), title: "Задача по умолчанию", isCompleted: false)
            viewModel.saveTask(defaultTask, forKey: defaultTask.id.uuidString)
            allTasks.append(defaultTask)
        }
        
        tasks = allTasks.map { TaskCellViewModel(task: $0) }
        tableView.reloadData()
        
        printTasksStatus() // MARK: проверка статусов
    }
    
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let taskVM = tasks[indexPath.row]
        
        cell.textLabel?.text = taskVM.title
        cell.accessoryType = taskVM.isCompleted ? .checkmark : .none
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVM = tasks[indexPath.row]
        
        guard var task = viewModel.getTask(forKey: taskVM.id.uuidString) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        print("Нажата задача:")
        print("ID: \(task.id.uuidString), Title: \"\(task.title)\", isCompleted: \(task.isCompleted)")
        
        task.isCompleted.toggle()
        viewModel.updateTask(task, forKey: task.id.uuidString)
        
        tasks[indexPath.row] = TaskCellViewModel(task: task)
        
        print(" ")
        print("Обновленная задача:")
        print("ID: \(task.id.uuidString), Title: \"\(task.title)\", isCompleted: \(task.isCompleted)")
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: удаление задачи из списка свайпом вправо
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            let taskVM = self.tasks[indexPath.row]
            self.viewModel.deleteTask(forKey: taskVM.id.uuidString)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.printTasksStatus()
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
