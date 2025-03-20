import UIKit

class DetailMovieView: UIView {
    var onTrailerButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Constant.grayColor
    }

    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.backgroundColor = Constant.grayColor
        return scroll
    }()


    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = Constant.imageMediumCornerRadius
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()

    lazy var imageCarouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Constant.screenWidth, height: Constant.screenHeight / 3)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(ImageCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ImageCarouselCollectionViewCell.reuseIndetifier)
        return collection
    }()

    func setupImageCarouselCollectionViewDataSource(dataSource: UICollectionViewDataSource) {
        imageCarouselCollectionView.dataSource = dataSource
    }

    lazy var mainTitle: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: Constant.Font.poppinsSemiBold, size: 18)
        text.numberOfLines = Constant.DetailView.titleNumberOfLines
        return text
    }()
    
    
    private lazy var raitingIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = Constant.orangeColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .star
        return icon
    }()
    
    lazy var raitingLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = Constant.orangeColor
        return text
    }()
    
    private lazy var openTrailerButton: UIButton = {
        let action = UIAction { _ in
            self.onTrailerButtonTapped?()
        }
        
        let button = UIButton(primaryAction: action)
        button.frame = .init(x: 10, y: 10, width: 50, height: 50)
        let image = UIImage(systemName: "play")?.withTintColor(Constant.orangeColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var trailerRaitingLabel: UILabel = {
        let text = UILabel()
        text.text = "Трейлер"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .white
        return text
    }()
 
    private lazy var trailerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [openTrailerButton, trailerRaitingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .center
        stack.layer.cornerRadius = Constant.DetailView.cornerRadiusStackView
        stack.backgroundColor = UIColor.init(hex: "252836").withAlphaComponent(0.9)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return stack
    }()
    
    private lazy var raitingStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [raitingIcon, raitingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .center
        stack.layer.cornerRadius = Constant.DetailView.cornerRadiusStackView
        stack.backgroundColor = UIColor.init(hex: "252836").withAlphaComponent(0.9)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return stack
    }()

    private lazy var stackViewMovieInfo: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constant.DetailView.stackViewSpaicing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func createSeparatorLabel() -> UILabel {
        let label = UILabel()
        label.text = "|"
        label.textColor = UIColor.init(hex: Constant.DetailView.colorLabelText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.init(hex: Constant.DetailView.colorLabelText)
        label.text = text
        label.font = UIFont(name: Constant.Font.poppinsMedium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createIcon(with nameIcon: UIImage) -> UIImageView {
        let icon = UIImageView()
        icon.image = nameIcon
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor.init(hex: Constant.DetailView.colorLabelText)
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }
    
    private func createIconLabelStack(icon: UIImage, text: String) -> UIStackView {
        let iconView = createIcon(with: icon)
        let label = createLabel(with: text)
        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    func updateLabelForStackView(data: String, duration: String, genre: String) {
        let iconDataStack = createIconLabelStack(icon: .calendarBlank, text: data)
        let separator1 = createSeparatorLabel()
        let iconDurationStack = createIconLabelStack(icon: .clock, text: duration)
        let separator2 = createSeparatorLabel()
        let iconGenreStack = createIconLabelStack(icon: .ticket, text: genre)
        
        stackViewMovieInfo.addArrangedSubview(iconDataStack)
        stackViewMovieInfo.addArrangedSubview(separator1)
        stackViewMovieInfo.addArrangedSubview(iconDurationStack)
        stackViewMovieInfo.addArrangedSubview(separator2)
        stackViewMovieInfo.addArrangedSubview(iconGenreStack)
    }

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["О фильме", "Актеры"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = UIColor.init(hex: Constant.DetailView.colorLabelText)

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: Constant.Font.poppinsExtraBold, size: 14)!
        ]
        segment.setTitleTextAttributes(selectedAttributes, for: .selected)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: Constant.Font.poppinsMedium, size: 14)!
        ]
        segment.setTitleTextAttributes(normalAttributes, for: .normal)
        return segment
    }()

    lazy var descriptionLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 12)
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = Constant.DetailView.descriptionNumberOfLines
        return text
    }()

    lazy var starsLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = Constant.DetailView.descriptionNumberOfLines
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 12)
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isHidden = true
        return text
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, starsLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupLayout() {
        addSubview(scroll)
        scroll.addSubview(contentView)
        contentView.addSubview(imageCarouselCollectionView)
        contentView.addSubview(stackViewMovieInfo)
        contentView.addSubview(posterImage)
        contentView.addSubview(mainTitle)
        contentView.addSubview(segmentControl)
        contentView.addSubview(stackView)
        contentView.addSubview(raitingStackView)
        contentView.addSubview(trailerStackView)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: Constant.Padding.medium),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor),

            imageCarouselCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCarouselCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCarouselCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCarouselCollectionView.heightAnchor.constraint(equalToConstant: Constant.screenHeight / 3),
            
            raitingStackView.bottomAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor, constant: -Constant.Padding.small),
            raitingStackView.trailingAnchor.constraint(equalTo: imageCarouselCollectionView.trailingAnchor, constant: -Constant.Padding.small),
            
            trailerStackView.bottomAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor, constant: -Constant.Padding.small),
            trailerStackView.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constant.Padding.small),
            
            posterImage.centerYAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Padding.large),
            posterImage.heightAnchor.constraint(equalTo: imageCarouselCollectionView.heightAnchor, multiplier: 0.5),
            posterImage.widthAnchor.constraint(equalToConstant: Constant.screenWidth / 3.5),

            mainTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Padding.small),
            mainTitle.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: Constant.Padding.medium),
            mainTitle.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: -Constant.Padding.xxxxLarge),

            stackViewMovieInfo.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: Constant.Padding.large),
            stackViewMovieInfo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackViewMovieInfo.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.7),

            segmentControl.topAnchor.constraint(equalTo: stackViewMovieInfo.bottomAnchor, constant: Constant.Padding.xxLarge),
            segmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Padding.small),
            segmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Padding.small),
            
            stackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Constant.Padding.xxLarge),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Padding.large),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Padding.large),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Padding.large),
        ])
    }
}
