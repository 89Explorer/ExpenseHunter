//
//  AddAmountViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/17/25.
//


import UIKit

final class AddAmountViewController: UIViewController {
    
    // MARK: - Variable
    // 계산한 값을 전달할 클로저
    var onAmountSelected: ((Int) -> Void)?
    private var rawExpression: String = "" {
        didSet {
            updateDisplay()
        }
    }
    
    
    // MARK: - UI Component
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.text = "₩ 0 원"
        label.numberOfLines = 1
        return label
    }()
    
    private let keypadRows: [[String]] = [
        ["(", ")", "⌫", "C"],
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "−"],
        ["0", ".", "=", "+"],
        ["완료"]
    ]
    
    private lazy var keypadStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        generateButtons()
    }
    
    private func setupUI() {
        view.addSubview(displayLabel)
        view.addSubview(keypadStack)
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            keypadStack.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 24),
            keypadStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keypadStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func generateButtons() {
        for row in keypadRows {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8
            hStack.distribution = .fillEqually
            
            for key in row {
                let button = UIButton(type: .system)
                button.setTitle(key, for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                button.layer.cornerRadius = 8
                button.backgroundColor = .secondarySystemFill
                button.heightAnchor.constraint(equalToConstant: 48).isActive = true
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                hStack.addArrangedSubview(button)
            }
            
            keypadStack.addArrangedSubview(hStack)
        }
    }
    
    private func updateDisplay() {
        let formatted = formatExpression(rawExpression)
        displayLabel.text = formatted
    }
    
    // 입력값: 계산기 또는 금액 입력 필드로부터 받은 String  (예: "123456", "123×2" 등)
    // 반환값: 사용자에게 보여줄 포맷된 문자열 (예: "₩ 123,456 원")
    private func formatExpression(_ input: String) -> String {
        
        // 계산식 입력 시 사용되는 기호들을 Swift가 인식 가능한 연산자로 변환 (예: "123×2" → "123*2")
        let sanitized = input
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
        
        // Double(sanitized)로 입력값이 숫자일 경우에만 포맷을 적용
        // 단, +, -, *, / 등의 연산자가 입력값에 포함되지 않은 경우에만 해당
        // 사용자가 "123456"처럼 단순 숫자를 입력했을 때만 처리
        // "123×2" 같이 수식이 포함되면 포맷하지 않음
        if let result = Double(sanitized),
           !input.contains("+") && !input.contains("-") &&
            !input.contains("*") && !input.contains("/") {
            
            // 세 자리마다 쉼표(,)를 추가한 문자열로 변환
            // 예: 123456 → "₩ 123,456 원"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let numberText = formatter.string(from: NSNumber(value: result)) ?? "0"
            return "₩ \(numberText) 원"
        }
        
        // 계산식 등 숫자가 아닐 경우 그대로 반환
        return input
    }
    
    
    // 입력값: 계산식 문자열 (예: "1,200 + 300", "₩ 1,000 × 3 원", "((200+300)×2)")
    // 반환값: 계산된 결과를 Double로 리턴 (예: 1500.0)
    func evaluateExpression(from rawExpression: String) -> Double {
        
        // 입력된 문자열을 계산 가능한 형태로 정리
        // "₩", "원", ",", " " → 모두 제거 (숫자 계산에 필요 없는 것들)
        // 예: "₩ 1,000 × 3 원" → "1000*3" / "2,000 − 500" → "2000-500"
        let sanitized = rawExpression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "₩", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "원", with: "")
            .replacingOccurrences(of: " ", with: "")

        
        // 빈 문자열은 바로 0 리턴 (예: 입력: "" 또는 "₩ 원" → 출력: 0)
        guard !sanitized.isEmpty else {
            print("❌ 빈 수식")
            return 0
        }
        

        // 괄호 쌍 검사 (오류 방지용)
        // 괄호 쌍이 맞지 않으면 계산 불가능하므로 0 리턴 (예: "((200+300)*2" → ❌)
        let openCount = sanitized.filter { $0 == "(" }.count
        let closeCount = sanitized.filter { $0 == ")" }.count
        guard openCount == closeCount else {
            print("❌ 괄호 쌍 불일치: '\(sanitized)'")
            return 0
        }
        

        // NSExpression으로 계산 시도
        // 성공 시 NSNumber 타입으로 결과 반환 → Double로 변환
        // 실패 시 0 리턴
        // 예: "1000+200*3" → 1600.0 / "2000/(2+3)" → 400.0
        do {
            let expression = NSExpression(format: sanitized)
            if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
                return result.doubleValue
            } else {
                print("❌ 계산 실패: \(sanitized)")
                return 0
            }
        } catch {
            print("❌ NSExpression 예외: \(error.localizedDescription)")
            return 0
        }
    }


    
    // MARK: - Action Method
    // 키패드 버튼이 눌렸을 때 실행됨
    // 버튼의 title(for: .normal)을 가져와 어떤 키가 눌렸는지 판단
    @objc private func keyPressed(_ sender: UIButton) {
        
        
        // 버튼에 표시된 글자를 가져옴 (예: "1", "+", "=", "C", "⌫" 등)
        // 값이 없으면 아무것도 하지 않음 (return)
        guard let key = sender.title(for: .normal) else { return }

        switch key {
            
        // 입력된 계산식 전부 지움
        case "C":
            rawExpression = ""

        // 비어있지 않으면 마지막 글자 삭제 (예: 예: "1200+" → "1200")
        case "⌫":
            if !rawExpression.isEmpty {
                rawExpression.removeLast()
            }

        // 수식 계산
        // 핵심 포인트: guard !rawExpression.isEmpty else { return } ← ✅ 이 부분이 앱 강제 종료 방지 핵심
        case "=":
            guard !rawExpression.isEmpty else { return }
            let result = evaluateExpression(from: rawExpression)
            rawExpression = result == 0 ? "" : String(result)

        // 값 전달 및 종료
        // 수식이 비어있으면 0 전달하고 dismiss
        // 그렇지 않으면 계산된 결과(Int) 전달하고 dismiss
        // 예: rawExpression = "1000+500" → 결과 1500 → onAmountSelected?(1500)
        case "완료":
            guard !rawExpression.isEmpty else {
                onAmountSelected?(0)
                dismiss(animated: true)
                return
            }
            let result = evaluateExpression(from: rawExpression)
            onAmountSelected?(Int(result))
            dismiss(animated: true)

        default:
            rawExpression += key
        }

        updateDisplay()
    }

}
