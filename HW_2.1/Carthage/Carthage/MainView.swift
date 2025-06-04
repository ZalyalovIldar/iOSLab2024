//
//  MainView.swift
//  Carthage
//
//  Created by Damir Rakhmatullin on 22.03.25.
//

import UIKit

class MainView: UIView {
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://c.tenor.com/wLXDQEM9Mb8AAAAd/tenor.gif"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var imageView2: UIImageView = {
       let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://c.tenor.com/DIYahHaupqAAAAAC/tenor.gif"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var imageView3: UIImageView = {
       let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://c.tenor.com/HR3YZjYlr_UAAAAC/tenor.gif"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, imageView2, imageView3])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = .white
        addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
