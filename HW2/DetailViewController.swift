import Foundation
import UIKit

class DetailViewController: UIViewController {
    private var images: [UIImage] = []
    private var moment: Moment!
    // Замыкания для обновления и удаления
    var onUpdateMoment: ((Moment) -> Void)?
    var onDeleteMoment: ((Moment) -> Void)?
    
    init(moment: Moment, onUpdateMoment: ((Moment) -> Void)? = nil, onDeleteMoment: ((Moment) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.moment = moment
        self.onUpdateMoment = onUpdateMoment
        self.onDeleteMoment = onDeleteMoment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagesStack)
        view.addSubview(descriptionStack)
        return view
    }()
    
    lazy var imagesStack: UIStackView = {
        let imagesStack = UIStackView()
        imagesStack.axis = .vertical
        imagesStack.spacing = 5
        imagesStack.distribution = .fillEqually
        imagesStack.translatesAutoresizingMaskIntoConstraints = false
        return imagesStack
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    lazy var descriptionStack: UIStackView = {
        let stack = UIStackView()
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
            
            imagesStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imagesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionStack.topAnchor.constraint(equalTo: imagesStack.bottomAnchor, constant: 10),
            descriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        imagesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch images.count {
        case 1:
            imagesStack.addArrangedSubview(createImageView(with: images[0]))
        case 2:
            let horizontalStackView = UIStackView(arrangedSubviews: [
                createImageView(with: images[0]),
                createImageView(with: images[1])
            ])
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = 5
            imagesStack.addArrangedSubview(horizontalStackView)
        case 3:
            let topStack = UIStackView(arrangedSubviews: [
                createImageView(with: images[0]),
                createImageView(with: images[1])
            ])
            topStack.axis = .horizontal
            topStack.spacing = 5
            topStack.distribution = .fillEqually
            
            imagesStack.addArrangedSubview(topStack)
            imagesStack.addArrangedSubview(createImageView(with: images[2]))
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }
    
    private func setupNavigationBar() {
        let editAction = UIAction { _ in
            let editVC = EditViewController(moment: self.moment)
            editVC.completion = { [weak self] updatedMoment in
                guard let self = self else { return }
                self.moment = updatedMoment
                self.configure()
                self.onUpdateMoment?(updatedMoment)
            }
            
            let navVC = UINavigationController(rootViewController: editVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let deleteAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "Уверены, что хотите удалить?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.onDeleteMoment?(self.moment)
                self.navigationController?.popToRootViewController(animated: true)
            })
            self.present(alert, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", primaryAction: editAction)
        toolbarItems = [UIBarButtonItem(systemItem: .trash, primaryAction: deleteAction)]
        navigationController?.setToolbarHidden(false, animated: false)
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
