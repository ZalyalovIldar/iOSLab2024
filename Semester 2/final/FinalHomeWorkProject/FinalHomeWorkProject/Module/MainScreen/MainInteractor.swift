//
//  MainIteractor.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import Foundation
import Combine

protocol MainInteractorInput {
    var remindersPublisher: AnyPublisher<[Reminder], Never> { get }
}

protocol MainInteractorOutput: AnyObject {
    
}


final class MainInteractor: MainInteractorInput {
    weak var presenter: MainInteractorOutput?
    
    private let remindersService: ReminderServiceProtocol
    
    init(remindersService: ReminderServiceProtocol = ServiceLocator.shared.configureReminderService()) {
        self.remindersService = remindersService
    }
    
    var remindersPublisher: AnyPublisher<[Reminder], Never> {
        remindersService.remindersPublisher
    }
}
