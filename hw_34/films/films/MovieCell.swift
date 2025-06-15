//
//  MovieCell.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let numberImageView = UIImageView() 

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настройка posterImageView
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        numberImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(numberImageView)
        
        // Добавляем констрейнты для изображения, текста и номера
        NSLayoutConstraint.activate([
            // Констрейнты для posterImageView
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 144.61), // Задаем фиксированную ширину 144.61
            posterImageView.heightAnchor.constraint(equalToConstant: 210),
            

            // Констрейнты для numberImageView
                        numberImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8), // Размещаем внизу
                        numberImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15), // Слева
                        numberImageView.widthAnchor.constraint(equalToConstant: 57.84), // Размер изображения номера
                        numberImageView.heightAnchor.constraint(equalToConstant: 70.42) // Размер изображения номера
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Сбрасываем изображение постера
        posterImageView.image = nil
            
        }

    func configure(with movie: Movie, number: Int, isTopMovie: Bool) {
            // Загрузка изображения
            loadImage(from: movie.poster.image)
            // Установка текста названия
            // Устанавливаем изображение номера только для топ фильмов
            numberImageView.isHidden = !isTopMovie // Скрываем изображение, если это не топ фильм
            if isTopMovie {
                // Заменяем цифры на изображения с префиксом "number" + index
                numberImageView.image = UIImage(named: "number\(number)") // Используем number вместо index
            }
        
        // Настройка размера и скругления для топовых фильмов
                if isTopMovie {
                    posterImageView.layer.cornerRadius = 16 // Скругление углов для топовых фильмов
                } else {
                    // Для обычных фильмов (не топовых)
                    posterImageView.layer.cornerRadius = 16 // Скругление углов для обычных фильмов
                    posterImageView.layer.borderWidth = 0 // Убираем рамку для обычных фильмов
                    posterImageView.layer.borderColor = UIColor.clear.cgColor // Убираем цвет рамки
                    posterImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true // Для обычных фильмов ширина 100
                    posterImageView.heightAnchor.constraint(equalToConstant: 145.92).isActive = true // Для обычных фильмов высота 145.92
                }
            }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Асинхронная загрузка изображения
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

