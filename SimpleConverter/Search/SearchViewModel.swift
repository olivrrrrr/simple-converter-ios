import Foundation

protocol FlagDelegate {
    func updateFlag()
}

final class SearchViewModel {

    enum Constants {
       static let title = "Search"
    }

    var delegate: SelectFlagDelegate?
    var coordinator: AppCoordinator?
    var currencyService: CurrencyServicingType
    
    init(currencyService: CurrencyServicingType) {
        self.currencyService = currencyService
    }
    
    var filteredArray: [MetaData] = [] {
        didSet {
            onUpdate()
        }
    }
    
    var metaDataArray: [MetaData] = [] {
        didSet {
            onUpdate()
        }
    }
    
    var onUpdate: (() -> Void) = {}
    
    func didSelectItem(at indexPath: IndexPath) {
        let metaData = filteredArray[indexPath.row]
        delegate?.didSelectFlag(url: metaData.url, currency: metaData.assetId)
        coordinator?.dismissSearchViewController()
    }
    
    func filterSearch(_ searchText: String) {
        if searchText.isEmpty {
            filteredArray = metaDataArray
        } else {
            filteredArray = metaDataArray.filter { $0.assetId.lowercased().contains(searchText.lowercased()) }
        }
    }

    func fetchMetaData() {
        currencyService.fetchMetaData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let metaData):
                    self.metaDataArray = metaData
                    self.filteredArray = self.metaDataArray
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
