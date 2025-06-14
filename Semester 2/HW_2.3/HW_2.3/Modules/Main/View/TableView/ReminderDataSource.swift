//
//  ReminderDataSource.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UIKit

final class ReminderDataSource: NSObject, UITableViewDataSource {
    private var dataSource: [Reminder] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier) as? ReminderTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }

    func getReminder(at index: Int) -> Reminder{
        dataSource[index]
    }

    func updateDataSource(with items: [Reminder]) {
        dataSource = items
    }

    func add(_ item: Reminder) {
        dataSource.append(item)
    }
}
