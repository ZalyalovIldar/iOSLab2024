//
//  TodoViewModel.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

final class TodoViewModel {
    
    private var storageService: any Storage<Todo>
    
    private(set) var todos: [Todo] = [] {
        didSet {
            onTodosUpdated?()
            onTableBackgroundUpdate?()
        }
    }
    var onTodosUpdated: (() -> Void)?
    var onTableBackgroundUpdate: (() -> Void)?
    var onShowCreateTodoAlert: ((UIAlertController) -> Void)?
    var onShowDeleteTodoAlert: ((UIAlertController) -> Void)?
    var isButtonEnabled: Bool = true {
        didSet {
            rotateCreateTodoButton?(isButtonEnabled)
        }
    }
    var rotateCreateTodoButton: ((Bool) -> Void)?
    
    init(_ storageService: any Storage<Todo>) {
        self.storageService = storageService
        loadInitialTodos()
    }
    
    func showCreateTodoAlert() {
        let ac = UIAlertController(title: "New Todo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Create", style: .default) { [weak ac, weak self] _ in
            self?.isButtonEnabled.toggle()
            guard let todoTitle = ac?.textFields![0].text else { return }
            let newTodo = Todo(id: UUID(), title: todoTitle, isFinished: false)
            self?.todos.append(newTodo)
            
            self?.storageService.save(newTodo)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.isButtonEnabled.toggle()
        }
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        onShowCreateTodoAlert?(ac)
    }
    
    func showDeleteTodoActionSheet(at indexPath: IndexPath) {
        let ac = UIAlertController(title: todos[indexPath.row].title, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Finish", style: .default) { [weak self] _ in
            guard let self else { return }
            let removedTodo = todos[indexPath.row]
            todos.remove(at: indexPath.row)
            storageService.delete(removedTodo)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        
        onShowDeleteTodoAlert?(ac)
    }
}

private extension TodoViewModel {
    
    func loadInitialTodos() {
        todos = storageService.getAll()
        onTodosUpdated?()
    }
}
