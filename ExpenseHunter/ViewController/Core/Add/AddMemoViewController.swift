//
//  AddMemoViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/17/25.
//

import UIKit

class AddMemoViewController: UIViewController {
    
    // MARK: - Variable
    var existingMemo: String?
    var onMemoEntered: ((String) -> Void)?
    
    // 1. 변수로 제약을 저장할 프로퍼티 추가
    private var saveButtonBottomConstraint: NSLayoutConstraint!

    
    // MARK: - UI Component
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .systemBackground
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 16, right: 12)
        tv.layer.cornerRadius = 12
        tv.isScrollEnabled = true
        return tv
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemBlue
        return button
    }()
    
    
    // MARK: - Init
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(saveMemo), for: .touchUpInside)
        
        //setupKeyboardNotification()
        addKeyboardObservers()
    }
    
    
    // MARK: - Function
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        title = "메모 작성"
        view.addSubview(textView)
        view.addSubview(saveButton)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. 제약 설정 시 저장
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            saveButtonBottomConstraint // ⭐️ 이건 나중에 constant만 변경
        ])
        
        
        textView.text = existingMemo
        textView.becomeFirstResponder()
        
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    // MARK: - Action Method
    @objc private func saveMemo() {
        onMemoEntered?(textView.text)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let keyboardHeight = keyboardFrame.height
        saveButtonBottomConstraint.constant = -keyboardHeight - 8 // 키보드 위에 8pt 여유

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func handleKeyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        saveButtonBottomConstraint.constant = -16 // 원래대로

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

}



// MARK: - Extension: textView가 키보드에 가리는 것을 막기 위한 목적
extension AddMemoViewController {
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -bottomInset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
}
