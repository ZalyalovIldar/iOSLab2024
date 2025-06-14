//
//  MainInteractor.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Combine

protocol MainInteractorInput: AnyObject {
    var remindersPublisher: AnyPublisher<[Reminder], Never> { get }
}

protocol MainInteractorOutput: AnyObject {
}


final class MainInteractor: MainInteractorInput {
    weak var presenter: MainInteractorOutput?
    private let remindersService: ReminderServiceProtocol

    init(remindersService: ReminderServiceProtocol = ServiceLocator.shared.remindersService) {
        self.remindersService = remindersService
    }

    var remindersPublisher: AnyPublisher<[Reminder], Never> {
        remindersService.remindersPublisher
    }
}
