//
//  Bulder.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 10.04.2025.
//

import UIKit

class Bulder {
    
    static func getTaskViewConroller() -> UIViewController {
        let viewModel = TaskListViewModel()
        let viewController = TaskListViewController(viewModel: viewModel)
        return viewController
    }
}
