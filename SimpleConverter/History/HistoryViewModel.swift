import Foundation

final class HistoryViewModel: ObservableObject {
    
    enum Constants {
       static let title = "Conversion History"
    }
    
    func fetchConversion() -> [Conversion]?  {
        CoreDataManager.shared.fetchConversion()
    }
    
    func groupByDateAndSort() -> [(Date, [Conversion])] {
        guard let savedCurrencies = fetchConversion() else { return [] }
        
        var grouped: [Date: [Conversion]] = [:]
        
        savedCurrencies.forEach { conversion in
            guard let date = conversion.date else { return }
            let calendar = Calendar.current
            let roundedDate = calendar.startOfDay(for: date)
            
            if var existingConversions = grouped[roundedDate] {
                existingConversions.append(conversion)
                grouped[roundedDate] = existingConversions
            } else {
                grouped[roundedDate] = [conversion]
            }
        }
        
        let sortedGrouped = grouped.sorted(by: { $0.key > $1.key })

        let sortedArray = sortedGrouped.map { ($0.key, $0.value) }
        
        return sortedArray
    }
}
