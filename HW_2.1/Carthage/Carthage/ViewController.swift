//
//  ViewController.swift
//  Carthage
//
//  Created by Damir Rakhmatullin on 22.03.25.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    lazy var mainView: UIView = {
        let mainView = MainView()
        return mainView;
    
    }()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}

