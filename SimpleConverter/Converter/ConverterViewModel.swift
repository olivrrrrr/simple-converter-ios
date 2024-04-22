import Foundation

enum KeypadBehaviour: Equatable {
    case appendNumberAfterDot(_ number: Int)
    case appendNumberBeforeDot(_ number: Int)
}

enum Flag {
    case first
    case second
}

final class ConverterViewModel {
    
    enum Constants {
        static let title = "Currency Converter"
    }
    
    var firstCurrencyFlag: String
    var secondCurrencyFlag: String
    var isFirstFlagSelected: Bool
    var isSecondFlagSelected: Bool
    var dotPressed: Bool
    var currencyArray: [Currency]
    var initialNumber: String
    var secondNumber: String
    var coordinator: AppCoordinator?
    var maxNumberOfIntegersDisplayed: Int
    let currencyService: CurrencyServicingType
    
    var onUpdate: ((String) -> Void)?
    
    init(firstCurrencyFlag: String = "USD",
         secondCurrencyFlag: String = "BTC",
         isFirstFlagSelected: Bool = false,
         isSecondFlagSelected: Bool = false,
         dotPressed: Bool = false,
         currencyArray: [Currency] = [],
         initialNumber: String = "0",
         secondNumber: String = "0.00",
         maxNumberOfIntegersDisplayed: Int = 10,
         currencyService: CurrencyServicingType) {
        self.firstCurrencyFlag = firstCurrencyFlag
        self.secondCurrencyFlag = secondCurrencyFlag
        self.isFirstFlagSelected = isFirstFlagSelected
        self.isSecondFlagSelected = isSecondFlagSelected
        self.dotPressed = dotPressed
        self.currencyArray = currencyArray
        self.initialNumber = initialNumber
        self.secondNumber = secondNumber
        self.maxNumberOfIntegersDisplayed = maxNumberOfIntegersDisplayed
        self.currencyService = currencyService
    }
    
    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String) {
       currencyService.fetchCurrencyData(baseCurrency: baseCurrency, secondaryCurrency: secondaryCurrency) { [weak self] result in
            switch result {
            case .success(let currency):
                self?.currencyArray = currency
                print(currency)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createConversion() {
        if hasTwoDecimalPlaces(initialNumber) {
            CoreDataManager.shared.createConversion(date: Date(), initialCurrency: firstCurrencyFlag, initialAmount: initialNumber, secondaryCurrency: secondCurrencyFlag, secondaryAmount: secondNumber)
        }
    }
    
    func historyButtonPresseed() {
        coordinator?.presentHistoryViewController()
    }
    
    func flagPressed(_ flag: Flag) {
        switch flag {
        case .first:
            isFirstFlagSelected = true
        case .second:
            isSecondFlagSelected = true
        }
        
        coordinator?.presentSearchViewController(self)
    }
    
    func hasTwoDecimalPlaces(_ number: String) -> Bool {
        if let dotIndex = number.firstIndex(of: ".") {
            let decimalPart = number[dotIndex...]
            return decimalPart.dropFirst().count == 2
        }
        return false
    }
    
    func keypadBehaviour(tag: Int, currentText: String) -> String {
        var text = currentText
        
        let behaviour = nav(number: tag)
        
        switch behaviour {
        case .appendNumberBeforeDot(let number):
            if text.count < maxNumberOfIntegersDisplayed && !hasTwoDecimalPlaces(text) {
                text += String(number)
            }
        case .appendNumberAfterDot(let number):
            if !hasTwoDecimalPlaces(text) {
                text += String(number)
            }
        }
        return text
    }
    
    func nav(number: Int) -> KeypadBehaviour {
        if dotPressed {
            return .appendNumberAfterDot(number)
        } else {
            return .appendNumberBeforeDot(number)
        }
    }
    
    func updateSecondNumber() {
        guard let initial =  Float(initialNumber), let currency = currencyArray.first else { return }
        let value = initial * currency.rate
        secondNumber = value.roundedString
    }
}

extension ConverterViewModel: SelectFlagDelegate {
    func didSelectFlag(url: String, currency: String) {
        onUpdate?(url)
        if isFirstFlagSelected {
            firstCurrencyFlag = currency
            isFirstFlagSelected = false
        } else if isSecondFlagSelected {
            secondCurrencyFlag = currency
            isSecondFlagSelected = false
        }
        fetchCurrencyData(baseCurrency: firstCurrencyFlag, secondaryCurrency: secondCurrencyFlag)
    }
}
