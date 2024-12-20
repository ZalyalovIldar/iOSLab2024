//
//  UpdateMomentDelegate.swift
//  HW_2
//
//  Created by Павел Калинин on 20.10.2024.
//


import UIKit

protocol UpdateMomentDelegate: AnyObject {
    func updateMoment(moment: Moment)
    func deleteMoment(moment: Moment)
}

class DetailViewController: UIViewController {
    private var images: [UIImage] = []
    weak var delegate: UpdateMomentDelegate?
    private var moment: Moment!
    
    init(delegate: UpdateMomentDelegate? = nil, moment: Moment!) {
        super.init(nibName: nil, bundle: nil)
        self.moment = moment
        self.delegate = delegate
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagesStack)
        view.addSubview(descriptionStack)
        return view
    }()
    
    private lazy var imagesStack: UIStackView = {
        var imagesStack = UIStackView()
        imagesStack.axis = .vertical
        imagesStack.spacing = 5
        imagesStack.distribution = .fillEqually
        imagesStack.translatesAutoresizingMaskIntoConstraints = false
        return imagesStack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var descriptionStack: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        setupLayout()
        setupNavigationBar()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imagesStack.topAnchor.constraint(equalTo: contentView.topAnchor ,constant: 10),
            imagesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionStack.topAnchor.constraint(equalTo: imagesStack.bottomAnchor ,constant: 10),
            descriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        imagesStack.arrangedSubviews.forEach{$0.removeFromSuperview()}
        switch images.count {
        case 1:
            let imageView = createImageView(with: images[0])
            imagesStack.addArrangedSubview(imageView)
        case 2:
            let leftImageView = createImageView(with: images[0])
            let rightImageView = createImageView(with: images[1])
            let horizontalStackView = UIStackView(arrangedSubviews: [leftImageView, rightImageView])
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = 5
            imagesStack.addArrangedSubview(horizontalStackView)
        case 3:
            let topStack: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 5
                stackView.distribution = .fillEqually
                stackView.addArrangedSubview(createImageView(with: images[0]))
                stackView.addArrangedSubview(createImageView(with: images[1]))
                return stackView
            }()
            
            let bottomImage = createImageView(with: images[2])
            imagesStack.addArrangedSubview(topStack)
            imagesStack.addArrangedSubview(bottomImage)
        case 4:
            let topStack: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 5
                stackView.distribution = .fillEqually
                stackView.addArrangedSubview(createImageView(with: images[0]))
                stackView.addArrangedSubview(createImageView(with: images[1]))
                return stackView
            }()
            let bottomStack: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 5
                stackView.distribution = .fillEqually
                stackView.addArrangedSubview(createImageView(with: images[2]))
                stackView.addArrangedSubview(createImageView(with: images[3]))
                return stackView
            }()
            imagesStack.addArrangedSubview(topStack)
            imagesStack.addArrangedSubview(bottomStack)
        default:
            break
        }
        if !imagesStack.constraints.isEmpty {
            imagesStack.removeConstraints(imagesStack.constraints)
        }
        imagesStack.heightAnchor.constraint(equalToConstant: CGFloat((images.count / 2 + images.count % 2) * 200)).isActive = true
        imagesStack.layoutIfNeeded()
    }
    
    private func createImageView(with image: UIImage) -> UIImageView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = image
            return imageView
        }()
        return imageView
    }
    
    private func setupNavigationBar() {
        let editAction = UIAction { _ in
            let rootVC = EditMomentViewController(moment: self.moment)
            rootVC.completion = {[weak self] moment in
                guard let self = self else { return }
                self.moment = moment
                configure()
                delegate?.updateMoment(moment: moment)
                rootVC.dismiss(animated: true)
            }
            let vc = UINavigationController(rootViewController: rootVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        let deleteAction =  UIAction {[weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "Уверены, что хотите удалить?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
                self.delegate?.deleteMoment(moment: self.moment)
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", primaryAction: editAction)
        navigationController?.setToolbarHidden(false, animated: false)
        toolbarItems = [UIBarButtonItem(systemItem: .trash, primaryAction: deleteAction)]
    }
    
    private func configure() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        descriptionLabel.text = moment.description
        dateLabel.text = formatter.string(from: moment.date)
        images = moment.images
        
        setupStackView()
    }
}
