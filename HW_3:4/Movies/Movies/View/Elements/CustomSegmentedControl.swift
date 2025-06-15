//
//  SwipeableSegmentControl.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//


import UIKit

class CustomSegmentedControl<T>: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomSegmentCell.self, forCellWithReuseIdentifier: CustomSegmentCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private(set) var selectedIndex: Int = 0
    private var items: [T] = []
    private var titleProvider: ((T)->String)!
    var onSegmentSelected: ((T) -> Void)?

    init(items: [T], titleProvider: @escaping (T)->String) {
        super.init(frame: .zero)
        self.items = items
        self.titleProvider = titleProvider
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    //MARK: public methods
    func setSelectedIndex(_ index: Int) {
        guard index >= 0 && index < items.count else { return }

        let previousIndex = selectedIndex
        selectedIndex = index

        let previousIndexPath = IndexPath(item: previousIndex, section: 0)
        let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)

        if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CustomSegmentCell {
            previousCell.animateSelection(isSelected: false)
        }

        if let selectedCell = collectionView.cellForItem(at: selectedIndexPath) as? CustomSegmentCell {
            selectedCell.animateSelection(isSelected: true)
        }

        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        onSegmentSelected?(items[selectedIndex])
    }
    
    func updateDataSource(with items: [T]) {
        self.items = items
    }
    
    func getCurrentValue() -> T{
        return items[selectedIndex]
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    //MARK: methods UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomSegmentCell.reuseIdentifier, for: indexPath) as? CustomSegmentCell else {return UICollectionViewCell()}
        cell.configure(with: titleProvider(items[indexPath.item]), isSelected: indexPath.item == selectedIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedIndex(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = titleProvider(items[indexPath.item])
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
