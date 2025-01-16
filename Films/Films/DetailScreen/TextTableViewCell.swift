//
//  TextTableViewCell.swift
//  Films
//
//  Created by Артур Мавликаев on 11.01.2025.
//

import UIKit

final class TextCell: UITableViewCell {
    static let identifier = "TextCell"

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var cycleTimer: Timer?
    private var currentIndex: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cycleTimer?.invalidate()
        cycleTimer = nil
        currentIndex = 0
        mainLabel.text = nil
    }


    func configure(text: String, font: UIFont) {
        let cleanText = text.removingHTMLTags()
        mainLabel.font = font
        mainLabel.text = cleanText
    }


    func configureCycle(strings: [String], font: UIFont, interval: TimeInterval = 2.0) {
        cycleTimer?.invalidate()
        cycleTimer = nil
        currentIndex = 0

        guard !strings.isEmpty else {
            mainLabel.text = "Нет данных"
            return
        }

        guard strings.count > 1 else {
            mainLabel.font = font
            mainLabel.text = strings[0]
            return
        }

        mainLabel.font = font
        mainLabel.text = strings[0]

        cycleTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentIndex = (self.currentIndex + 1) % strings.count
            let nextText = strings[self.currentIndex]

            UIView.transition(
                with: self.mainLabel,
                duration: 0.6,
                options: .transitionCrossDissolve,
                animations: {
                    self.mainLabel.text = nextText
                },
                completion: nil
            )
        }
    }
}

extension String {
    func removingHTMLTags() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self
    }
}
