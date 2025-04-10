//
//  StorageServiceView.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import UIKit
protocol StorageServiceButtonDelegate: AnyObject {
    func addNote()
}

protocol TableViewCheckBoxButton: AnyObject {
    func toggleCheckboxState(noteId: UUID)
}
class StorageServiceView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var internalDataSource: TableViewDataSource = {
        let internalDataSource = TableViewDataSource(tableview: tableView)
        return internalDataSource
     }()
     
    
    var dataSource: TableViewDataSource? {
        return internalDataSource
    }
    
    weak var delegate: StorageServiceButtonDelegate?
    weak var checkBoxDelegate: TableViewCheckBoxButton?
    
    private lazy var addNoteButton: UIButton = {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.addNote()
        }
        let button = UIButton(type: .system, primaryAction: action)
        button.setTitle("ADD NOTE", for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [tableView, addNoteButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
 
    }

}

extension StorageServiceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = internalDataSource.dataSource.itemIdentifier(for: indexPath) else { return }
        checkBoxDelegate?.toggleCheckboxState(noteId: item.id)
    }
}
