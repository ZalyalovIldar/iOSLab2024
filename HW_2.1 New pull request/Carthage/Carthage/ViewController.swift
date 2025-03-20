//
//  ViewController.swift
//  Carthage
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var mainView: MainView {
        self.view as! MainView
    }
    
    override func loadView() {
        self.view = MainView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

