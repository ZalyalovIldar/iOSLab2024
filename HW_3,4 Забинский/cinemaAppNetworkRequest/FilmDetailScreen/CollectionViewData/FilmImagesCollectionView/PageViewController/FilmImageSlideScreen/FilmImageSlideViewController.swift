//
//  FilmImageSlideViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 07.01.2025.
//

import UIKit

class FilmImageSlideViewController: UIViewController {
    
    var customView: FilmImageSlideView {
        view as! FilmImageSlideView
    }
    
    override func loadView() {
        super.loadView()
        view = FilmImageSlideView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.setDismissAction(dismiss: UIAction { _ in
            self.dismiss(animated: true)
        })
    }
}
