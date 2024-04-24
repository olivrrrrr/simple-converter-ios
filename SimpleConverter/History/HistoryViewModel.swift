import Foundation

final class HistoryViewModel: ObservableObject {
    
    enum Constants {
       static let title = "Conversion History"
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func fetchConversion() -> [Conversion]?  {
        CoreDataManager.shared.fetchConversion()
    }
    
    func getFormattedDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func groupByDate() -> [Date: [Conversion]]  {
        guard let savedCurrencies = fetchConversion() else { return [Date(): [Conversion]()]}
        let grouped = savedCurrencies.reduce(into: [Date: [Conversion]]()) { result, conversion in
            guard let date = conversion.date else { return }
    
            let calendar = Calendar.current
            let roundedDate = calendar.startOfDay(for: date)
    
            if var existingConversions = result[roundedDate] {
                existingConversions.append(conversion)
                result[roundedDate] = existingConversions
            } else {
                result[roundedDate] = [conversion]
            }
        }
        return Dictionary(uniqueKeysWithValues: grouped.sorted { $1.key > $0.key })
    }
}
