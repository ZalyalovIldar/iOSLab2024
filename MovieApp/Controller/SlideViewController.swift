//
//  ScrollViewController.swift
//  MovieApp
//
//  Created by Anna on 27.01.2025.
//

import UIKit

class SlideViewController: UIViewController {
    
    var customView: FilmImageSlideView {
        view as! FilmImageSlideView
    }
    
    override func loadView() {
        super.loadView()
        view = FilmImageSlideView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.setDismissAction(UIAction { _ in
            self.dismiss(animated: true)
        })
    }
}
