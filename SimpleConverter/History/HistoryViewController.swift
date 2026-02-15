import UIKit
import SwiftUI

final class HistoryViewController: UIHostingController<HistoryView> {
    
    init() {
        super.init(rootView: HistoryView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
