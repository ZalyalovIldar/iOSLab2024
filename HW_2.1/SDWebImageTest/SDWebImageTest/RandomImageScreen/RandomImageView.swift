//
//  RandomImageView.swift
//  SDWebImageTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit
import SDWebImage

final class RandomImageView: UIView {
    
    private(set) lazy var loadGifButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Load random gif", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var firstLoadedGif: UIImageView = {
        getImage()
    }()
    
    private lazy var secondLoadedGif: UIImageView = {
        getImage()
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            loadGifButton,
            firstLoadedGif,
            secondLoadedGif
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupPlaceholdersGifs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithGif(_ data: [String]) {
        guard let first = data.first,
              let last = data.last else { return }
        firstLoadedGif.sd_setImage(with: URL(string: first))
        secondLoadedGif.sd_setImage(with: URL(string: last))
    }
}

private extension RandomImageView {
    
    func setupPlaceholdersGifs() {
    
    }
    
    func setup() {
        self.backgroundColor = .white
        setupSubviews()
        setupContraints()
    }
    
    func setupSubviews() {
        addSubview(dataStackView)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            dataStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dataStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    func getImage() -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.sd_setImage(with: URL(string: "https://media.giphy.com/media/S5JILphSqWa32KrrPn/giphy.gif?cid=ecf05e47w8gv4kneqsroh1eomrk4ik2aemd2exp5ywble94f&ep=v1_gifs_search&rid=giphy.gif&ct=g"))
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
            image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4),
        ])
        return image
    }
}
