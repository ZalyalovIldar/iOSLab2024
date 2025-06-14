//
//  MainAssembly.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UIKit

final class MainAssembly {
    static func build() -> UIViewController {
        let vc = MainViewController()
        let presenter = MainPresenter()
        let router = MainRouter()
        let interactor = MainInteractor()
        
        vc.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.viewController = vc
        router.viewController = vc
        interactor.presenter = presenter

        return vc
    }
}
