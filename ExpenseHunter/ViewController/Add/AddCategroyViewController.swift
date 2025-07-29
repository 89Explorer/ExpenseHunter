//
//  AddCategroyViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/20/25.
//

import UIKit


class AddCategroyViewController: UIViewController {

    
    // MARK: - Variable
   var viewModel: TransactionViewModel!
   var onCategoryEntered: ((String) -> Void)?
    
    
    // MARK: - UI Component
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureUI()
    }
    
    
    // MARK: - Function
    private func configureUI() {
        
        collectionView.register(AddCategroyCell.self, forCellWithReuseIdentifier: AddCategroyCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
}


// MARK: - Extension: 컬렉션뷰 설정
extension AddCategroyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategroyCell.reuseIdentifier, for: indexPath) as? AddCategroyCell else { return UICollectionViewCell() }
        let category = viewModel.currentCategories[indexPath.item]
        let icon =  viewModel.currentCategoryIcons[category]
        cell.configure(title: category, iconSystemName: icon!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel.currentCategories[indexPath.item]
        onCategoryEntered?(selectedCategory)
        viewModel.transaction?.category = selectedCategory
        dismiss(animated: true)
    }
}
