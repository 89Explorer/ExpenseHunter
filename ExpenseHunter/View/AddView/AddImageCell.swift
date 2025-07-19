//
//  AddImageCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/18/25.
//

import UIKit

class AddImageCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "AddImageCell"
    weak var delegate: AddImageCellDelegate?
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let cameraButton: UIButton = UIButton(type: .custom)
    private let deleteButton: UIButton = UIButton(type: .custom)
    private let seperator: UIView = UIView()
    private let selectedImage: UIImageView = UIImageView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureTappedIamge()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImage.image = nil
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        
        titleLabel.text = ""
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        //titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let cameraImage = UIImage(systemName: "camera", withConfiguration: config)
        cameraButton.setImage(cameraImage, for: .normal)
        cameraButton.tintColor = .label
        cameraButton.contentHorizontalAlignment = .leading
        cameraButton.contentVerticalAlignment = .center
        //cameraButton.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        
        seperator.backgroundColor = .secondaryLabel
        
        selectedImage.backgroundColor = .secondarySystemBackground
        selectedImage.image = nil
        selectedImage.layer.cornerRadius = 12
        selectedImage.contentMode = .scaleAspectFill
        selectedImage.clipsToBounds = true
        selectedImage.isUserInteractionEnabled = true
        
        let innerStack: UIStackView = UIStackView(arrangedSubviews: [cameraButton, seperator, selectedImage])
        innerStack.axis = .vertical
        innerStack.spacing = 2
        innerStack.distribution = .fill
        innerStack.alignment = .leading
        
        let totalStack: UIStackView = UIStackView(arrangedSubviews: [titleLabel, innerStack])
        totalStack.axis = .horizontal
        totalStack.spacing = 20
        totalStack.distribution = .fill
        totalStack.alignment = .fill
        
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(.label, for: .normal)
        deleteButton.backgroundColor = .systemBackground
        deleteButton.layer.cornerRadius = 15
        deleteButton.isHidden = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(totalStack)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            totalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            totalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            totalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            //cameraButton.heightAnchor.constraint(equalToConstant: 30),
            cameraButton.widthAnchor.constraint(equalToConstant: 30),
            
            seperator.heightAnchor.constraint(equalToConstant: 2),
            //seperator.widthAnchor.constraint(equalTo: selectedImage.widthAnchor),
            selectedImage.heightAnchor.constraint(equalToConstant: 250),
            
            deleteButton.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor, constant: -4),
            deleteButton.topAnchor.constraint(equalTo: selectedImage.topAnchor, constant: 4),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func configureTappedIamge() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImage))
        selectedImage.addGestureRecognizer(tapGesture)
        
        cameraButton.addTarget(self, action: #selector(didTappedCamera), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTappedDeleteButton), for: .touchUpInside)
    }
    
    // 선택한 사진을 selectedImage에 전달 
    func setImage(_ image: UIImage?) {
        selectedImage.image = image
        deleteButton.isHidden = (image == nil)
    }
    
    
    // MARK: - Action Method
    @objc private func didTappedImage() {
        print("Image Tapped")
        guard let image = selectedImage.image else { return }
        delegate?.selectedImageTapped(image)
    }
    
    @objc private func didTappedDeleteButton() {
        print("image Delete")
        selectedImage.image = nil
        deleteButton.isHidden = true
    }
    
    @objc private func didTappedCamera() {
        print("Camera Tapped")
        delegate?.didTapCameraButton(in: self)
    }
}


// MARK: - Protocol: selectedImage를 눌렀을 떄 뷰컨트롤러 보여주는 델리게이트패턴
protocol AddImageCellDelegate: AnyObject {
    func selectedImageTapped(_ image: UIImage)
    // cameraButton을 눌렀을 때 동작할 메서드
    func didTapCameraButton(in cell: AddImageCell)
}
