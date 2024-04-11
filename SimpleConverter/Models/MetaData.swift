import Foundation

struct MetaData: Codable, Equatable {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case assetId = "asset_id"
        case url
    }

    let assetId: String
    let url: String

    init(assetId: String, url: String) {
        self.assetId = assetId
        self.url = url
    }
}
