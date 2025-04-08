//
//  TodoController.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

final class TodoController: UIViewController {
    
    private var todoView: TodoView {
        view as! TodoView
    }
    
    private var viewModel: TodoViewModel!
    private var todoTableViewDelegate: TodoTableViewDelegate?
    private var todoTableVewDiffableDataSource: TodoTableViewDataSource?
    
    private lazy var createButtonAction: UIAction = {
        UIAction { [weak self] _ in
            self?.viewModel.showCreateTodoAlert()
        }
    }()
    
    init(viewModel: TodoViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = TodoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCreateTodoButtonAction()
        setupViewModelCallBacks()
        setupTodoTableDelegateCallBacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        redrawTableViewBackground()
    }
}

private extension TodoController {
    
    func setupData() {
        todoTableViewDelegate = TodoTableViewDelegate()
        todoView.todoTableView.delegate = todoTableViewDelegate
        
        todoTableVewDiffableDataSource = TodoTableViewDataSource(viewModel: viewModel)
        todoTableVewDiffableDataSource?.setupDataSource(tableView: todoView.todoTableView)
    }
    
    func setupCreateTodoButtonAction() {
        todoView.createTodoButton.addAction(createButtonAction, for: .touchUpInside)
    }
    
    func setupViewModelCallBacks() {
        viewModel.onTodosUpdated = { [weak self] in
            self?.todoTableVewDiffableDataSource?.updateSnapshot(animation: true)
        }
        
        viewModel.onShowCreateTodoAlert = { [weak self] alertController in
            self?.viewModel.isButtonEnabled.toggle()
            self?.present(alertController, animated: true)
        }
        
        viewModel.onShowDeleteTodoAlert = { [weak self] alertContoller in
            self?.present(alertContoller, animated: true)
        }
        
        viewModel.rotateCreateTodoButton = { [weak self] isEnabled in
            self?.todoView.rotateButton(isEnabled)
        }
        
        viewModel.onTableBackgroundUpdate = { [weak self] in
            self?.redrawTableViewBackground()
        }
    }
    
    func setupTodoTableDelegateCallBacks() {
        todoTableViewDelegate?.onTodoDelete = { [weak self] indexPath in
            self?.viewModel.showDeleteTodoActionSheet(at: indexPath)
        }
    }
    
    func redrawTableViewBackground() {
        let isHidden = viewModel.todos.isEmpty
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.todoView.todoTableView.backgroundView?.isHidden = !isHidden
        }
    }
}
