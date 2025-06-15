//
//  MainPresenter.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import Foundation
import Combine

protocol MainPresenterInput {
    func showAddReminderFlow()
}

protocol MainPresenterOutput: AnyObject {
    func updateDataSource(reminders: [Reminder])
}

final class MainPresenter: MainPresenterInput, MainInteractorOutput {
    private let remindersService: ReminderService

    private var cancellables = Set<AnyCancellable>()
    weak var view: MainPresenterOutput?
    var router: MainRouterInput?
    var interactor: MainInteractorInput? {
        didSet {
            setupBinding()
        }
    }
    
    init(remindersService: ReminderService = ServiceLocator.shared.configureReminderService()) {
        self.remindersService = remindersService
    }
    
    
    func showAddReminderFlow() {
        router?.showAddReminderController()
    }
    
    func setupBinding() {
        interactor?.remindersPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] reminders in
                print(reminders)
                self?.view?.updateDataSource(reminders: reminders)
            }
            .store(in: &cancellables)
    }
}

