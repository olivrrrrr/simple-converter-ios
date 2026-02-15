import UIKit

protocol CurrencyServicingType {
    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String, completed: @escaping (Result<[Currency], AppError>) -> Void)
    func fetchMetaData(completed: @escaping (Result<[MetaData], AppError>) -> Void)
    var cache: NSCache<NSString, UIImage> { get }
}

enum AppError: String, Error {
    case invalidCurrency  = "This currency returned an invalid URL. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse  = "Invalid response from server. Please try again"
    case invalidData      = "The data received from the server was invalid. Please try again."
}

final class NetworkManager: CurrencyServicingType {
    // Using ExchangeRate-API which is free and doesn't require API key for basic usage
    private let baseURL = "https://open.er-api.com/v6/latest/"
    private let cryptoIconBaseURL = "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@1a63530be6e374711a8554f31b17e4cb92c25fa5/128/color/"
    var cache = NSCache<NSString, UIImage>()

    // Helper struct to decode ExchangeRate-API response
    private struct ExchangeRateResponse: Codable {
        let result: String
        let base_code: String
        let time_last_update_unix: Int
        let rates: [String: Float]
    }

    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String, completed: @escaping (Result<[Currency], AppError>) -> Void) {

        let endpoint = baseURL + "\(baseCurrency)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(ExchangeRateResponse.self, from: data)

                guard let rate = apiResponse.rates[secondaryCurrency] else {
                    completed(.failure(.invalidCurrency))
                    return
                }

                let timestamp = Date(timeIntervalSince1970: TimeInterval(apiResponse.time_last_update_unix))
                let dateFormatter = ISO8601DateFormatter()
                let timeString = dateFormatter.string(from: timestamp)

                let currency = Currency(
                    time: timeString,
                    assetIdBase: baseCurrency,
                    assetIdQuote: secondaryCurrency,
                    rate: rate
                )

                completed(.success([currency]))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func fetchMetaData(completed: @escaping (Result<[MetaData], AppError>) -> Void) {
        // Map currency codes to country codes for flag icons
        let currencyToCountry: [String: String] = [
            // Major Fiat Currencies
            "USD": "us", "EUR": "eu", "GBP": "gb", "JPY": "jp", "AUD": "au",
            "CAD": "ca", "CHF": "ch", "CNY": "cn", "SEK": "se", "NZD": "nz",
            "MXN": "mx", "SGD": "sg", "HKD": "hk", "NOK": "no", "KRW": "kr",
            "TRY": "tr", "INR": "in", "RUB": "ru", "BRL": "br", "ZAR": "za"
        ]

        // Cryptocurrencies (using crypto icon CDN)
        let cryptocurrencies = [
            "BTC", "ETH", "USDT", "BNB", "XRP", "ADA", "DOGE", "SOL", "DOT", "MATIC",
            "LTC", "SHIB", "TRX", "AVAX", "UNI", "LINK", "ATOM", "XLM", "ETC", "BCH"
        ]

        var metaDataList: [MetaData] = []

        // Add fiat currencies with flag icons
        for (currencyCode, countryCode) in currencyToCountry {
            let flagURL = "https://flagcdn.com/w80/\(countryCode).png"
            metaDataList.append(MetaData(assetId: currencyCode, url: flagURL))
        }

        // Add cryptocurrencies with crypto icons (symbols: BTC, ETH, etc.)
        for crypto in cryptocurrencies {
            let iconURL = "\(cryptoIconBaseURL)\(crypto.lowercased()).png"
            metaDataList.append(MetaData(assetId: crypto, url: iconURL))
        }

        // Sort alphabetically by currency/crypto symbol
        metaDataList.sort { $0.assetId < $1.assetId }

        // Return the list on the main thread
        DispatchQueue.main.async {
            completed(.success(metaDataList))
        }
    }
}
