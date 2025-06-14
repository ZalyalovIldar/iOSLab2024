//
//  ServiceLocator.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

final class ServiceLocator {
    static let shared = ServiceLocator()
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("Сервис \(T.self) не зарегистрирован")
        }
        return service
    }
}

extension ServiceLocator {
    var remindersService: ReminderService { resolve() }
    var notificationService: NotificationService { resolve() }
    var deeplinkHandler: DeeplinkHandler { resolve() }
}
