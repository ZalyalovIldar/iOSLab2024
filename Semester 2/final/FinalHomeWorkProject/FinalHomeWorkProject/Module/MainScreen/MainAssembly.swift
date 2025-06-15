//
//  MainAssembly.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 11.06.2025.
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
        presenter.view = vc
        router.view = vc
        interactor.presenter = presenter

        return vc
    }
}
