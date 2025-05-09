//
//  ViewController.swift
//  TestCarthage
//
//  Created by дилара  on 22.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 400, height: 500))
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: "https://ru.pinterest.com/pin/119486196358294537"), placeholderImage: UIImage(named: "placeholder"))
        self.view.addSubview(imageView)
    }


}


