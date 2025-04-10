//
//  StorageServiceViewController.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import UIKit

class StorageServiceViewController: UIViewController {
    
    private let contentView: StorageServiceView = .init()
    private let viewModel: StorageServiceViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ viewModel: StorageServiceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    private func setupNavigationBar() {
           title = "Generic Заметочки"
           navigationController?.navigationBar.barTintColor = .systemBlue
           navigationController?.navigationBar.tintColor = .white
       }
    
    private func setupContentView() {
        contentView.delegate = self
        contentView.dataSource?.applySnapshot(items: viewModel.notes)
        contentView.checkBoxDelegate = self
        
        setupNavigationBar()
    }

}

extension StorageServiceViewController: StorageServiceButtonDelegate {
    func addNote() {
        let alert = UIAlertController(
            title: "Добавить заметку",
            message: "Введите текст заметки:",
            preferredStyle: .alert
        )
            
        alert.addTextField { textField in
            textField.placeholder = "Текст заметки"
        }
            
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in }
            
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let noteText = alert.textFields?.first?.text, !noteText.isEmpty {
                self.saveNote(noteText)
            } else {
                self.showEmptyNoteAlert()
            }
        }
            
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveNote(_ noteText: String) {
        viewModel.addNote(title: noteText)
        contentView.dataSource?.applySnapshot(items: viewModel.notes)
    }
    
    private func showEmptyNoteAlert() {
        let emptyAlert = UIAlertController(
            title: "Ошибка",
            message: "Заметка не может быть пустой.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        emptyAlert.addAction(okAction)
        self.present(emptyAlert, animated: true, completion: nil)
    }
    
}
extension StorageServiceViewController: TableViewCheckBoxButton {
    func toggleCheckboxState(noteId: UUID) {
        if let index = viewModel.notes.firstIndex(where: { $0.id == noteId }) {
            viewModel.toggleCompletion(at: index)
            contentView.dataSource?.applySnapshot(items: viewModel.notes)
        }
    }
}
