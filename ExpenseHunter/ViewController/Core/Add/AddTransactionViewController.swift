//
//  AddTransactionViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit
import PhotosUI
import Combine

class AddTransactionViewController: UIViewController {
    
    
    // MARK: - Variable
    private let addSection: [String] = ["구분", "날짜", "금액", "분류", "자산출처", "내용"]
    private var transactionViewModel: TransactionViewModel
    private var cancellables = Set<AnyCancellable>()
    private let mode: AddTransactionMode
    
    private var selectedTransactionType: TransactionType = .expense {
        didSet {
            // 수입 / 지출 버튼이 선택되면 자동으로 date 섹션이 선택된 걸로 간주
            selectedIndexPath = IndexPath(row: 0, section: AddSection.date.rawValue)
            updateTitle()
            self.saveButton.backgroundColor = selectedTransactionType == .expense ? .systemRed : .systemGreen
            self.addTableView.reloadData()
        }
    }
    
    private var selectedIndexPath: IndexPath?
    private var currentImageCellIndexPath: IndexPath?    // 카메라 버튼이 눌린 셀을 기억하기 위한 indexPath
    
    // 선택된 날짜를 저장하기 위한 변수
    private var selectedDate: Date?
    private var selectedAmount: Int?
    private var selectedMemo: String?
    private var selectedImage: UIImage?     // 이건 안쓴다... 왜냐하면 셀 내부의 통신이기 때문에 전역적으로 관리할 필요 없다. 
    
    
    // MARK: - UI Component
    private let addTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let saveButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: - Init
    init(mode: AddTransactionMode) {
        self.mode = mode
        self.transactionViewModel = TransactionViewModel(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureUI()
        self.updateTitle()
        bindViewModel()
        //checkPhotoLibraryPermission()
        configureNavigationBar()
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$transaction
            .receive(on: RunLoop.main)
            .sink { [weak self] transaction in
                guard let self, let transaction else { return }
                self.addTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigationBar() {
        // 공통 네비게이션 바 설정
        switch mode {
        case .create:
            navigationItem.rightBarButtonItem = nil
        case .edit(id: _):
            let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteButtonTapped))
            deleteButton.tintColor = .systemRed
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    
    private func configureUI() {
        
        addTableView.showsVerticalScrollIndicator = false
        addTableView.layer.cornerRadius = 12
        addTableView.backgroundColor = .systemBackground
        addTableView.separatorStyle = .none
        addTableView.rowHeight = UITableView.automaticDimension
        addTableView.estimatedRowHeight = 100
        
        addTableView.dataSource = self
        addTableView.delegate = self
        
        addTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addTableView.register(AddTypeCell.self, forCellReuseIdentifier: AddTypeCell.reuseIdentifier)
        addTableView.register(AddCustomCell.self, forCellReuseIdentifier: AddCustomCell.reuseIdentifier)
        addTableView.register(AddImageCell.self, forCellReuseIdentifier: AddImageCell.reuseIdentifier)
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "OTSBAggroB", size: 20)
        saveButton.layer.cornerRadius = 16
        saveButton.backgroundColor = .systemRed
        saveButton.addTarget(self, action: #selector(didTappedSaveButton), for: .touchUpInside)
        
        view.addSubview(addTableView)
        view.addSubview(saveButton)
        addTableView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            addTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    // AddType에서 선택한 버튼에 따라 제목 설정
    func updateTitle() {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        switch selectedTransactionType {
        case .income:
            titleLabel.text = "수입 입력"
        case .expense:
            titleLabel.text = "지출 입력"
        }
        
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
    }
    
    // 경고창 열어주는 메서드
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // 삭제 경고창 메서드
    private func showDeleteConfirmationAlert() {
        let alert = UIAlertController(title: "내역 삭제", message: "지금 보고 계신 내역을 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            if case let .edit(id) = self.mode {
                self.transactionViewModel.deleteTransaction(by: id)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
        
    }

    
    // MARK: - ActionMethod
    @objc private func didTappedSaveButton() {
        guard transactionViewModel.validateTransaction() else {
            if let errorMessage = transactionViewModel.errorMessage {
                showAlert(message: errorMessage)
            }
            return
        }
        
        switch mode {
        case .create:
            transactionViewModel.createTransaction()
        case .edit(_):
            transactionViewModel.updateTransaction()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        // 삭제 로직을 구현
        print("삭제 시작!")
        showDeleteConfirmationAlert()
    }
}


// MARK: - Extension: 테이블뷰의 설정
extension AddTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = AddSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        
        switch section {
//        case .addType:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTypeCell.reuseIdentifier, for: indexPath) as? AddTypeCell else { return UITableViewCell() }
//            cell.delegate = self
//            cell.selectionStyle = .none
//            cell.configure(selectedType: selectedTransactionType)
//            return cell
        case .addType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTypeCell.reuseIdentifier, for: indexPath) as? AddTypeCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            
            if let typeString = transactionViewModel.transaction?.transaction,
               let transactionType = TransactionType(rawValue: typeString.rawValue) {
                cell.configure(selectedType: transactionType)
            } else {
                cell.configure(selectedType: nil) // 기본값 처리
            }

            return cell
            
        case .date, .amount, .category, .memo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCustomCell.reuseIdentifier, for: indexPath) as? AddCustomCell else { return UITableViewCell() }
            cell.configure(title: section.title)
            cell.selectionStyle = .none
            cell.delegate = self
            
            let isSelected = (indexPath == selectedIndexPath)
            cell.updateSeparatorColor(
                isSelected: isSelected,
                transactionType: selectedTransactionType
            )
            
            // 셀의 valueLabel 탭 제스처 연결
            cell.onValueLabelTapped = { [weak self] in
                self?.selectedIndexPath = indexPath
                self?.addTableView.reloadData()
                // 여기에 calendarView 또는 numberPad 띄우는 로직도 추가
            }
            
            if section == .date {
                if let selectedDate = selectedDate {
                    cell.updateDateValue(with: selectedDate)
                } else if let modelDate = transactionViewModel.transaction?.date {
                    cell.updateDateValue(with: modelDate)
                } else {
                    cell.updateDateValue(with: Date())
                }
            } else if section == .amount {
                if let selectedAmount = selectedAmount {
                    cell.updateAmountValue(with: selectedAmount)
                } else if let modelAmount = transactionViewModel.transaction?.amount {
                    cell.updateAmountValue(with: modelAmount)
                }
            } else  if section == .memo {
                if let selectedMemo = selectedMemo {
                    cell.updateMemoValue(with: selectedMemo)
                } else if let modelMemo = transactionViewModel.transaction?.memo {
                    cell.updateMemoValue(with: modelMemo)
                }
            } else {
                if let selectedCategory = transactionViewModel.transaction?.category {
                    cell.updateCategoryValue(with: selectedCategory)
                } else if let modelCategory = transactionViewModel.transaction?.category {
                    cell.updateCategoryValue(with: modelCategory)
                }
            }
            
            return cell
            
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddImageCell.reuseIdentifier, for: indexPath) as? AddImageCell else { return UITableViewCell() }
            cell.configure(title: section.title)
            cell.delegate = self
            if let selectedImage = transactionViewModel.transaction?.image {
                cell.setImage(selectedImage)
            }
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = AddSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .addType, .date, .amount, .category, .memo:
            return 52
            //return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}


// MARK: - Extension: AddType에서 선택한 버튼에 따라
extension AddTransactionViewController: AddTypeCellDelegate {
    func didSelectTransactionType(_ type: TransactionType) {
        selectedTransactionType = type
        transactionViewModel.transaction?.transaction = type   // viewModel 전달
        // 만약 .category 섹션도 갱신하려면 여기에 reload 추가
        // tableView.reloadSections([AddSection.category.rawValue], with: .automatic)
    }
}


// MARK: - Extension: 각 셀의 valueLabel을 눌렀을 떄 동작하는 기능 구현 목적
extension AddTransactionViewController: AddCustomCellDelegate {
    func valueLabelTapped(in cell: AddCustomCell) {
        guard let indexPath = addTableView.indexPath(for: cell),
              let section = AddSection(rawValue: indexPath.section) else { return }
        
        selectedIndexPath = indexPath
        
        switch section {
        case .date:
            print("날짜 valueLabel 눌림")
            presentCalendarPicker()
        case .amount:
            print("금액 valueLabel 눌림")
            presentAmountCalculator()
        case .category:
            print("분류 valueLabel 눌림")
            presentCategoryPicker()
        case .memo:
            print("메모 valueLabel 눌림")
            presentMemoPicker(currentMemo: selectedMemo)
        default:
            print("기타 valueLabel 눌림")
        }
        
        // ✅ 선택 효과를 위해 셀 리로드
        self.addTableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    // 날짜를 선택하는 AddDateViewController를 여는 메서드
    private func presentCalendarPicker() {
        let dateVC = AddDateViewController()
        dateVC.modalPresentationStyle = .pageSheet
        
        dateVC.onDateSelected = { [weak self] selectedDate in
            print("🔁 Date picked: \(selectedDate)")
            self?.selectedDate = selectedDate
            self?.transactionViewModel.transaction?.date = selectedDate   // ViewModel 전달
            self?.addTableView.reloadRows(at: [IndexPath(row: 0, section: AddSection.date.rawValue)], with: .none)
        }
        
        if let sheet = dateVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(dateVC, animated: true)
    }
    
    // 금액을 선택하는 AddAmountViewController를 여는 메서드
    private func presentAmountCalculator() {
        let amountVC = AddAmountViewController()
        amountVC.modalPresentationStyle = .pageSheet
        
        amountVC.onAmountSelected = { [weak self] amount in
            guard let self = self else { return }
            self.selectedAmount = amount
            self.transactionViewModel.transaction?.amount = amount
            
            // 금액 셀 업데이트
            self.addTableView.reloadRows(
                at: [IndexPath(row: 0, section: AddSection.amount.rawValue)],
                with: .none
            )
        }
        
        if let sheet = amountVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(amountVC, animated: true)
    }
    
    // 메모를 선택하는 AddMemoViewController를 여는 메서드
    private func presentMemoPicker(currentMemo: String?) {
        let memoVC = AddMemoViewController()
        memoVC.modalPresentationStyle = .pageSheet
        memoVC.existingMemo = currentMemo
        
        memoVC.onMemoEntered = { [weak self] memo in
            self?.selectedMemo = memo
            self?.transactionViewModel.transaction?.memo = memo   // viewModel에 전달
            self?.addTableView.reloadRows(at: [IndexPath(row: 0, section: AddSection.memo.rawValue)], with: .none)
        }
        
        if let sheet = memoVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(memoVC, animated: true)
    }
    
    private func presentCategoryPicker() {
        let categoryVC = AddCategroyViewController()
        categoryVC.modalPresentationStyle = .pageSheet
        categoryVC.viewModel = transactionViewModel
        categoryVC.onCategoryEntered = { [weak self] category in
            
            self?.transactionViewModel.transaction?.category = category
            self?.addTableView.reloadRows(at: [IndexPath(row: 0, section: AddSection.category.rawValue)], with: .none)
        }
        
        if let sheet = categoryVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(categoryVC, animated: true)
    }
    
}


// MARK: - Extension: AddImageCell 내에서 selectedImage를 눌렀을 때 동작할 메서드
extension AddTransactionViewController: AddImageCellDelegate {
    func deleteImage(_ image: UIImage?) {
        if image != nil {
            transactionViewModel.transaction?.image = image
        } else {
            transactionViewModel.transaction?.image = nil
        }
    }
    
    func didTapCameraButton(in cell: AddImageCell) {
        // 눌린 셀의 indexPath 저장
        if let indexPath = addTableView.indexPath(for: cell) {
            currentImageCellIndexPath = indexPath
            showCameraAndAlbum()
        }
    }
    
    
    func selectedImageTapped(_ image: UIImage) {
        let popupVC = PopupImageViewController(image: image)
        popupVC.modalPresentationStyle = .formSheet // 또는 .fullScreen, .automatic
        navigationController?.pushViewController(popupVC, animated: true)
    }
    
}


// MARK: - Extension: 카메라와 앨범 접근권한 설정하는 메서드
extension AddTransactionViewController {
    private func checkPhotoLibraryPermission() {
        
        MediaPermissionManager.shared.checkAndRequestIfNeeded(.album) { [weak self] granted in
            guard let self else { return }
            if granted {
                print("앨범 접근 승인")
            } else {
                print("앨범 접근 불허")
                self.showPermissionAlert(title: "앨범 접근이 필요합니다.", message: "설정에서 권한을 허용해주세요 ")
            }
        }
        
        MediaPermissionManager.shared.checkAndRequestIfNeeded(.camera) { [weak self] granted in
            guard let self else { return }
            if granted {
                print("카메라 접근 승인")
            } else {
                print("카메라 접근 불허")
                self.showPermissionAlert(title: "카메라 접근이 필요합니다.", message: "설정에서 권한을 허용해주세요 ")
            }
        }
        
    }
    
    func showPermissionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}


// MARK: - Extension: 카메라 및 앨범 실행 부분
extension AddTransactionViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    private func showCameraAndAlbum() {
        let alert = UIAlertController(title: "카메라 또는 앨범 선택", message: nil, preferredStyle: .actionSheet)
        
        let showCameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            print("카메라 선택")
            MediaPermissionManager.shared.checkAndRequestIfNeeded(.camera) { [weak self] granted in
                guard let self else { return }
                if granted {
                    self.openCamera()
                } else {
                    self.showPermissionAlert(title: "카메라 권한이 필요합니다.", message: "설정으로 이동하여 권한을 승인하세요")
                }
            }
            //self.openCamera()
        }
        
        let choosePhotoAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            print("사진첩 선택")
            MediaPermissionManager.shared.checkAndRequestIfNeeded(.album) { [weak self] granted in
                guard let self else { return }
                if granted {
                    print("사진첩을 선택헤서 사진첩으로 접근합니다.")
                    self.presentPhotoPicker()
                } else {
                    self.showPermissionAlert(title: "사진첩 권한이 필요합니다.", message: "설정으로 이동하여 권한을 승인하세요")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(showCameraAction)
        alert.addAction(choosePhotoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("카메라 접근 권한이 필요합니다.")
        }
    }
    
    // 카메라로 찍은 이미지 사용
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        //        let receiptVC = ReceiptViewController(receiptImage: image)
        //        receiptVC.modalPresentationStyle = .fullScreen
        //        self.present(receiptVC, animated: true)
        
        DispatchQueue.main.async {
            //            let receiptVC = ReceiptViewController(receiptImage: image)
            //            let nav = UINavigationController(rootViewController: receiptVC)
            //            nav.modalPresentationStyle = .fullScreen
            //            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            //               let window = windowScene.windows.first,
            //               let rootVC = window.rootViewController {
            //                rootVC.present(nav, animated: true)
            //            }
            self.transactionViewModel.transaction?.image = image
            self.applySelectedImageToCell(image)
        }
    }
    
    // 사진첩에서 사진선택 및 설정하는 함수
    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // 사진첩에서 선택하나 후 호출되는 함수
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let image = object as? UIImage else { return }
            
            DispatchQueue.main.async {
                //                let receiptVC = ReceiptViewController(receiptImage: image)
                //                let nav = UINavigationController(rootViewController: receiptVC)
                //                nav.modalPresentationStyle = .fullScreen
                //                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                //                   let window = windowScene.windows.first,
                //                   let rootVC = window.rootViewController {
                //                    rootVC.present(nav, animated: true)
                //                }
                
                self.transactionViewModel.transaction?.image = image
                self.applySelectedImageToCell(image)
            }
            
        }
    }
    
    // 선택한 사진을 selectedImage가 있는 AddImageCell로 전달하기 위한 메서드를 호출하는 메서드
    private func applySelectedImageToCell(_ image: UIImage) {
        guard let indexPath = currentImageCellIndexPath,
              let cell = addTableView.cellForRow(at: indexPath) as? AddImageCell else { return }
        cell.setImage(image) // AddImageCell에 setImage(image:) 같은 함수 구현 필요
    }
    
    @objc private func addReceipt() {
        self.showCameraAndAlbum()
    }
    
}


// MARK: - Enum: 작성 테이블 섹션 관리
enum AddSection: Int, CaseIterable {
    case addType
    case date
    case amount
    case category
    case memo
    case image
    
    
    var title: String {
        switch self {
        case .date: return "날짜"
        case .amount: return "금액"
        case .category: return "분류"
        case .memo: return "메모"
        case .image: return "사진"
        default: return ""
        }
    }
}


// MARK: - Enum: 모드 정의
enum AddTransactionMode {
    case create
    case edit(id: UUID)
}
