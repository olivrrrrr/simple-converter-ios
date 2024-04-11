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
    private let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    private let apikey = ENV.API
    private let metaBaseURL = "https://rest.coinapi.io/v1/assets/icons/200"
    var cache = NSCache<NSString, UIImage>()
    
    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String, completed: @escaping (Result<[Currency], AppError>) -> Void) {
        
        let endpoint = baseURL + "\(baseCurrency)" + "/\(secondaryCurrency)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
           "X-CoinAPI-Key": apikey
       ]

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                let response = try decoder.decode(Currency.self, from: data)
               completed(.success([response]))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func fetchMetaData(completed: @escaping (Result<[MetaData], AppError>) -> Void) {
       
        let endpoint = metaBaseURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
           "X-CoinAPI-Key": apikey
       ]

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
               let response = try decoder.decode([MetaData].self, from: data)
                
                completed(.success(response))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
