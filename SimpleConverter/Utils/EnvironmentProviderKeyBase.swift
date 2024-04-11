import Foundation

protocol APIKeyable {
    var API: String { get }
}

class EnvironmentProviderKeyBase {
    
    let dict: NSDictionary
    
    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath)
        else {
            fatalError("Couldn't find file \(resourceName) plist")
        }
        self.dict = plist
    }
}

final class EnvironmentProviderKey: EnvironmentProviderKeyBase, APIKeyable {
    
    init() {
        super.init(resourceName: "API_KEY")
    }
    
    var API: String {
        dict.object(forKey: "API") as? String ?? ""
    }
}
