import Foundation

struct Currency: Codable {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case time
        case assetIdBase = "asset_id_base"
        case assetIdQuote = "asset_id_quote"
        case rate
    }

    let time: String
    let assetIdBase: String
    let assetIdQuote: String
    let rate: Float
    
    init(time: String, assetIdBase: String, assetIdQuote: String, rate: Float) {
        self.time = time
        self.assetIdBase = assetIdBase
        self.assetIdQuote = assetIdQuote
        self.rate = rate
    }
}
