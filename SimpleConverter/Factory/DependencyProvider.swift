import Foundation

struct DependencyProvider {
    static var searchViewController: SearchViewController {
        let searchVC = SearchViewController()
        searchVC.viewModel = searchViewModel
        return searchVC
    }
    
    static var converterViewController: ConverterViewController {
        let converterVC = ConverterViewController()
        converterVC.viewModel = converterViewModel
        return converterVC
    }
    
    static var currencyService: CurrencyServicingType {
        let currencyService: CurrencyServicingType = NetworkManager()
        return currencyService
    }
    
    private static var converterViewModel: ConverterViewModel {
        let converterVM = ConverterViewModel(currencyService: currencyService)
        return converterVM
    }
    
    private static var searchViewModel: SearchViewModel {
        let searchViewModel = SearchViewModel(currencyService: currencyService)
        return searchViewModel
    }
}
