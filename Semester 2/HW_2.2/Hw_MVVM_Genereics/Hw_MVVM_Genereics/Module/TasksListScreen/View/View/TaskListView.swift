//
//  TaskListView.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

protocol TableViewCellActionDelegate: AnyObject {
    func deleteTaskBy(id: Int)
}

class TaskListView: UIView {
    weak var delegate: TableViewCellActionDelegate?
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(ListTaskTableViewCell.self,
                       forCellReuseIdentifier: ListTaskTableViewCell.reuseIndentifier)
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.96, alpha: 1)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: TableViewDelegate
extension TaskListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.deleteTaskBy(id: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableSection = TableSection.allCases[section]
        let headerView = UIView()
        let headerLabel = Label(numberOfLinesLabel: 1, sizeFont: 14, fontWeight: .semibold)
        headerLabel.textColor = .black
        headerLabel.text = tableSection.title
        headerView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
