//
//  ViewController.swift
//  SDWebImageExample
//
//  Created by Артур Мавликаев on 22.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 200, height: 200))
        view.addSubview(imageView)
        
        if let url = URL(string: "https://kpfu.ru/docs/F96864302174/img2060699502.jpg") {
            imageView.sd_setImage(with: url, completed: nil)
        }
    }



}

