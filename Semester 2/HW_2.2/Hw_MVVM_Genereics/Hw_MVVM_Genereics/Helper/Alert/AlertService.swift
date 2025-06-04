//
//  AlertService.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 11.04.2025.
//

import UIKit

class AlertService {
    static func showAddTaskAlert(viewController: UIViewController,
                                 completion: @escaping (String, String) -> Void) {
        let alert = UIAlertController(
            title: "Новая задача",
            message: "Введите текст задачи",
            preferredStyle: .alert
        )
        
        alert.addTextField { $0.placeholder = "Введите название заметки" }
        alert.addTextField { $0.placeholder = "Введите текст заметки" }
        
        let addAction = UIAlertAction(title: "Добавить", style: .cancel) { _ in
            guard
                let title = alert.textFields?[0].text?.trimmed,
                let description = alert.textFields?[1].text?.trimmed,
                !title.isEmpty,
                !description.isEmpty
            else {
                showErrorAlert(on: viewController)
                return
            }
            completion(title, description)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
    
    static func showErrorAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: "Ошибка",
            message: "Все поля должны быть заполнены",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Окей", style: .default))
        viewController.present(alert, animated: true)
    }
    
    static func showDeleteConfirmation(viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Предупреждение",
            message: "Вы действительно хотите удалить задачу?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
}
