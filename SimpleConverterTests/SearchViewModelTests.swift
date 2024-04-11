import XCTest
@testable import SimpleConverter

final class SearchViewModelTests: XCTestCase {
    
    var sut: SearchViewModel!
    var mockCurrencyService: MockCurrencyService!
    var mockDelegate: MockDelegate!
    var mockMetaDataArray: [MetaData]!
    
    override func setUpWithError() throws {
        mockCurrencyService = MockCurrencyService()
        sut = SearchViewModel(currencyService: mockCurrencyService)
        mockDelegate = MockDelegate()
        mockMetaDataArray = [
            MetaData(assetId: "USD", url: "usd-url"),
            MetaData(assetId: "EUR", url: "eur-url"),
            MetaData(assetId: "GBP", url: "gbp-url")
        ]
        sut.delegate = mockDelegate
        sut.filteredArray = mockMetaDataArray
        sut.metaDataArray = mockMetaDataArray
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        mockCurrencyService = nil
        sut = nil
        mockMetaDataArray = nil
        try super.tearDownWithError()
    }
    
    func test_fetchMetaData() {
        // given
        let result = MetaData(assetId: "", url: "")
        mockCurrencyService.fetchMockMetaDataResult = .success([result])

        let expectation = XCTestExpectation(description: "Fetch metadata expectation")

        // when
        sut.fetchMetaData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        // then
        XCTAssertEqual(sut.metaDataArray, [result])
    }

    func test_didSelectItem() {
        // given
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        sut.didSelectItem(at: indexPath)
        
        // then
        let result = MetaData(assetId: "USD", url: "usd-url")
        XCTAssertEqual(mockDelegate.selectedCurrencyUrl, result.url)
        XCTAssertEqual(mockDelegate.selectedCurrency, result.assetId)
        XCTAssertEqual(mockDelegate.methodsCalled, ["didSelectFlag(url:currency:)"])
    }

    func test_filterSearch_emptyText() {
        // given
        let searchText = ""
        
        // when
        sut.filterSearch(searchText)
        
        // then
        XCTAssertEqual(sut.filteredArray, mockMetaDataArray)
    }
    
    func test_filterSearch_nonEmptyText() {
        // given
        let searchText = "usd"
        
        // when
        sut.filterSearch(searchText)
        
        // then
        let result = [MetaData(assetId: "USD", url: "usd-url")]
        XCTAssertEqual(sut.filteredArray, result)
    }
}

final class MockDelegate: SelectFlagDelegate {
    
    var methodsCalled = [String]()
    
    var selectedCurrencyUrl: String?
    var selectedCurrency: String?
    
    func didSelectFlag(url: String, currency: String) {
        selectedCurrencyUrl = url
        selectedCurrency = currency
        methodsCalled.append(#function)
    }
}

final class MockCurrencyService: CurrencyServicingType {
    var fetchMockCurrencyResult: Result<[Currency], AppError>?
    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String, completed: @escaping (Result<[Currency], AppError>) -> Void) {
        if let fetchMockCurrencyResult {
            completed(fetchMockCurrencyResult)
        }
    }
    
    var fetchMockMetaDataResult: Result<[MetaData], AppError>?
    func fetchMetaData(completed: @escaping (Result<[MetaData], AppError>) -> Void) {
        if let fetchMockMetaDataResult {
            completed(fetchMockMetaDataResult)
        }
    }
    
    var cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
}
