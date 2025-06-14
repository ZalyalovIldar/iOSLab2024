//
//  MainPresenter.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UIKit
import Combine

protocol MainPresenterInput {
    func showAddReminderModule()
    func showDetailedReminderModule(reminder: Reminder)
}

final class MainPresenter: MainPresenterInput, MainInteractorOutput {
    weak var viewController: MainViewController?
    var interactor: MainInteractorInput? {
        didSet {
            setupBinding()
        }
    }
    var router: MainRouterInput?
    private let remindersService: ReminderService
    private var cancellables: Set<AnyCancellable> = []

    init(remindersService: ReminderService = ServiceLocator.shared.resolve()) {
        self.remindersService = remindersService
    }

    func showAddReminderModule() {
        router?.showAddReminderModule()
    }

    func showDetailedReminderModule(reminder: Reminder) {
        router?.showDetailedReminderModule(reminder: reminder)
    }

    func setupBinding() {
        interactor?.remindersPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] reminders in
                self?.viewController?.updateUI(with: reminders)
            }
            .store(in: &cancellables)
    }
}
