//
//  RandomImageController.swift
//  SDWebImageTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit

final class RandomImageController: UIViewController {
    
    private let gifData = [
        "https://i.gifer.com/7Eyn.gif",
        "https://i.gifer.com/NMhq.gif",
        "https://i.gifer.com/IIM.gif",
        "https://i.gifer.com/UwPC.gif",
        "https://i.gifer.com/47tv.gif",
        "https://i.gifer.com/Un3j.gif",
        "https://i.gifer.com/Jun.gif",
        "https://i.gifer.com/oNW.gif"
    ]
    
    private var randomImageView: RandomImageView {
        view as! RandomImageView
    }
    
    override func loadView() {
        view = RandomImageView()
        randomImageView.loadGifButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let randomGifs = gifData.shuffled().prefix(2)
            randomImageView.setupWithGif(Array(randomGifs))
        }, for: .touchUpInside)
    }
}
