import UIKit

final class ConverterViewController: UIViewController {
    
    private let secondNumberSubView: UIView = {
        let secondNumberSubView = UIView()
        return secondNumberSubView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let numberView: UIView = {
        let numberView = UIView()
        numberView.translatesAutoresizingMaskIntoConstraints = false
        return numberView
    }()
    
    private let numberSubView: UIView = {
        let numberSubView = UIView()
        numberSubView.translatesAutoresizingMaskIntoConstraints = false
        return numberSubView
    }()
    
    private let flag: UIImageView = {
        let flag = UIImageView()
        flag.translatesAutoresizingMaskIntoConstraints = false
        return flag
    }()
    
    private let secondFlag: UIImageView = {
        let flag = UIImageView()
        flag.translatesAutoresizingMaskIntoConstraints = false
        return flag
    }()
    
    private lazy var initialNumber: UILabel = {
        var initialNumber = UILabel()
        initialNumber.text = viewModel.initialNumber
        return initialNumber
    }()
    
    private lazy var secondNumber: UILabel = {
        let secondNumber = UILabel()
        secondNumber.text = viewModel.secondNumber
        return secondNumber
    }()
    
    private let keyboardStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: ConverterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpFlags()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNumberPad()
    }
    
    @objc private func clearNumber() {
        initialNumber.text?.removeAll()
        viewModel.initialNumber = "0"
        viewModel.dotPressed = false
        initialNumber.text = viewModel.initialNumber
        updateSecondNumber()
    }
    
    @objc private func pressedNumber(_ sender: UIButton) {
        let tag = sender.tag
        if initialNumber.text == "0" {
            initialNumber.text?.removeAll()
        }
        numberButtonTapped(tag: tag)
        if viewModel.hasTwoDecimalPlaces(viewModel.initialNumber) {
            CoreDataManager.shared.createConversion(date: Date(), initialCurrency: viewModel.firstCurrencyFlag, initialAmount: viewModel.initialNumber, secondaryCurrency: viewModel.secondCurrencyFlag, secondaryAmount: viewModel.secondNumber)
        }
        updateSecondNumber()
    }
    
    @objc private func flagPressed() {
        viewModel.onUpdate = updateFlags
        viewModel.flagPressed(.first)
    }
    
    @objc private func secondFlagPressed() {
        viewModel.onUpdate = updateFlags
        viewModel.flagPressed(.second)
    }
    
    private func updateFlags(_ url: String) {
        if viewModel.isFirstFlagSelected {
            flag.downloaded(from: url)
        } else if viewModel.isSecondFlagSelected {
            secondFlag.downloaded(from: url)
        }
        self.resetUI()
    }
    
    @objc private func dotButtonPressed() {
        if initialNumber.text?.firstIndex(of: ".") == nil {
            viewModel.initialNumber += "."
            initialNumber.text = viewModel.initialNumber
            viewModel.dotPressed = true
        }
    }
    
    @objc private func historyButtonPressed() {
        viewModel.historyButtonPresseed()
    }
    
    private func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String) {
        viewModel.fetchCurrencyData(baseCurrency: baseCurrency, secondaryCurrency: secondaryCurrency)
    }

    private func resetUI() {
        initialNumber.text = "0"
        secondNumber.text = "0.00"
        viewModel.dotPressed = false
    }
    
    private func updateSecondNumber() {
        viewModel.updateSecondNumber()
        secondNumber.text = viewModel.secondNumber
    }

    private func updateInitialNumberLabel(text: String) {
        viewModel.initialNumber = text
        initialNumber.text = viewModel.initialNumber
     }

     private func numberButtonTapped(tag: Int) {
         guard let currentText = initialNumber.text else { return }
         let newText = viewModel.keypadBehaviour(tag: tag, currentText: currentText)
         updateInitialNumberLabel(text: newText)
     }
}

extension ConverterViewController {
    private func setupUI() {
        title = ConverterViewModel.Constants.title
    
        let historyButton = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .plain, target: self, action: #selector(historyButtonPressed))
        historyButton.tintColor = .label
        navigationItem.rightBarButtonItem = historyButton

        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(numberView)
        NSLayoutConstraint.activate([
            numberView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            numberView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            numberView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            numberView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        numberView.addSubview(numberSubView)
        NSLayoutConstraint.activate([
            numberSubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            numberSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            numberSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            numberSubView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        numberView.addSubview(secondNumberSubView)
        secondNumberSubView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondNumberSubView.topAnchor.constraint(equalTo: numberSubView.bottomAnchor),
            secondNumberSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondNumberSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondNumberSubView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        numberSubView.addSubview(flag)
        
        NSLayoutConstraint.activate([
            flag.leadingAnchor.constraint(equalTo: numberSubView.leadingAnchor, constant: 20),
            flag.centerYAnchor.constraint(equalTo: numberSubView.centerYAnchor),
            flag.heightAnchor.constraint(equalToConstant: 40),
            flag.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        numberSubView.addSubview(initialNumber)
        initialNumber.translatesAutoresizingMaskIntoConstraints = false
        initialNumber.text = viewModel.initialNumber
        initialNumber.font = .systemFont(ofSize: 50.0, weight: .thin)
        initialNumber.textAlignment = .right
        initialNumber.adjustsFontSizeToFitWidth = true
        initialNumber.minimumScaleFactor = 0.5

        NSLayoutConstraint.activate([
            initialNumber.leadingAnchor.constraint(equalTo: flag.trailingAnchor),
            initialNumber.trailingAnchor.constraint(equalTo: numberSubView.trailingAnchor, constant: -10),
            initialNumber.centerYAnchor.constraint(equalTo: numberSubView.centerYAnchor),
            initialNumber.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        secondNumberSubView.addSubview(secondFlag)
        NSLayoutConstraint.activate([
            secondFlag.leadingAnchor.constraint(equalTo: secondNumberSubView.leadingAnchor, constant: 20),
            secondFlag.centerYAnchor.constraint(equalTo: secondNumberSubView.centerYAnchor),
            secondFlag.heightAnchor.constraint(equalToConstant: 40),
            secondFlag.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        secondNumberSubView.addSubview(secondNumber)
        
        secondNumber.translatesAutoresizingMaskIntoConstraints = false
        secondNumber.font = .systemFont(ofSize: 50.0, weight: .thin)
        secondNumber.textAlignment = .right
        secondNumber.adjustsFontSizeToFitWidth = true
        secondNumber.minimumScaleFactor = 0.5
        
        NSLayoutConstraint.activate([
            secondNumber.leadingAnchor.constraint(equalTo: secondFlag.trailingAnchor),
            secondNumber.trailingAnchor.constraint(equalTo: secondNumberSubView.trailingAnchor, constant: -10),
            secondNumber.centerYAnchor.constraint(equalTo: secondNumberSubView.centerYAnchor),
            secondNumber.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNumberPad() {
        view.addSubview(keyboardStack)
        keyboardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardStack.topAnchor.constraint(equalTo: numberView.bottomAnchor),
            keyboardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let buttonSize = view.frame.size.width / 3
    
        let zeroButton = UIButton(frame: CGRect(x: buttonSize,
                                            y: keyboardStack.frame.size.height+buttonSize*3,
                              width: buttonSize,
                              height: buttonSize))
        zeroButton.setTitleColor(.label, for: .normal)
        zeroButton.backgroundColor = .systemBackground
        zeroButton.setTitle("0", for: .normal)
        zeroButton.tag = 0
        keyboardStack.addSubview(zeroButton)
        
        let dotButton = UIButton(frame: CGRect(x: buttonSize*0,
                                            y: keyboardStack.frame.size.height+buttonSize*3,
                              width: buttonSize,
                              height: buttonSize))
        dotButton.setTitleColor(.label, for: .normal)
        dotButton.backgroundColor = .systemBackground
        dotButton.setTitle(".", for: .normal)
        keyboardStack.addSubview(dotButton)
        dotButton.addTarget(self, action: #selector(dotButtonPressed), for: .touchUpInside)
        
        let clearButton = UIButton(frame: CGRect(x: buttonSize*2,
                                            y: keyboardStack.frame.size.height+buttonSize*3,
                              width: buttonSize,
                              height: buttonSize))
        clearButton .setTitleColor(.label, for: .normal)
        clearButton .backgroundColor = .systemBackground
        clearButton .setTitle("C", for: .normal)
        keyboardStack.addSubview(clearButton)

        for num in 0..<3 {
            let button = UIButton(frame: CGRect(x: buttonSize * CGFloat(num),
                                                y: keyboardStack.frame.size.height+(buttonSize*2),
                                  width: buttonSize,
                                  height: buttonSize))
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .systemBackground
            button.setTitle("\(num+1)", for: .normal)
            button.tag = num + 1
            keyboardStack.addSubview(button)
            button.addTarget(self, action: #selector(pressedNumber(_:)), for: .touchUpInside)
        }
        
        for num in 0..<3 {
            let button = UIButton(frame: CGRect(x: buttonSize * CGFloat(num),
                                                y: keyboardStack.frame.size.height+(buttonSize*1),
                                  width: buttonSize,
                                  height: buttonSize))
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .systemBackground
            button.setTitle("\(num+4)", for: .normal)
            button.tag = num + 4
            keyboardStack.addSubview(button)
            button.addTarget(self, action: #selector(pressedNumber(_:)), for: .touchUpInside)
        }
        
        for num in 0..<3 {
            let button = UIButton(frame: CGRect(x: buttonSize * CGFloat(num),
                                                y: keyboardStack.frame.size.height+(buttonSize*0),
                                  width: buttonSize,
                                  height: buttonSize))
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .systemBackground
            button.setTitle("\(num+7)", for: .normal)
            button.tag = num + 7
            keyboardStack.addSubview(button)
            button.addTarget(self, action: #selector(pressedNumber(_:)), for: .touchUpInside)
        }
        
       // Action
        zeroButton.addTarget(self, action: #selector(pressedNumber(_:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearNumber), for: .touchUpInside)
    }
    
    private func setUpFlags() {
        fetchCurrencyData(baseCurrency: viewModel.firstCurrencyFlag, secondaryCurrency: viewModel.secondCurrencyFlag)
        flag.downloaded(from: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_512/0a4185f21a034a7cb866ba7076d8c73b.png")
        secondFlag.downloaded(from: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_512/4caf2b16a0174e26a3482cea69c34cba.png")
        
        flag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flagPressed)))
        flag.isUserInteractionEnabled = true
        
        secondFlag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondFlagPressed)))
        secondFlag.isUserInteractionEnabled = true
    }
}
