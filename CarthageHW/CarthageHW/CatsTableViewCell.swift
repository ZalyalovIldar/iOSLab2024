//
//  CatsTableViewCell.swift
//  CarthageHW
//
//  Created by Павел on 22.03.2025.
//

import UIKit

class CatsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var catImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private func setupUI() {
        contentView.addSubview(catImageView)
        
        NSLayoutConstraint.activate([
            catImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            catImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(with cat: Cat) {
        
        catImageView.sd_setImage(with: URL(string: cat.url), placeholderImage: UIImage(named: "placeholder.png"))
    }

}

extension CatsTableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

