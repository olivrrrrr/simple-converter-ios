import SwiftUI

struct HistoryView: View {
    
    @State var savedCurrencies = CoreDataManager.shared.fetchConversion()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func groupByDate(savedCurrencies: [Conversion]) -> [Date: [Conversion]]  {
        let grouped = savedCurrencies.reduce(into: [Date: [Conversion]]()) { result, conversion in
            guard let date = conversion.date else { return }
            // Round the date to ignore the time component
            let calendar = Calendar.current
            let roundedDate = calendar.startOfDay(for: date)
    
            // If the date already exists in the result, append the conversion to its array
            if var existingConversions = result[roundedDate] {
                existingConversions.append(conversion)
                result[roundedDate] = existingConversions
            } else {
                // Otherwise, create a new array with the conversion and add it to the result
                result[roundedDate] = [conversion]
            }
        }
        return grouped
    }
    
    var groupedByDate: [Date: [Conversion]] {
        return groupByDate(savedCurrencies: savedCurrencies!)
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedByDate.keys.sorted(by: >), id: \.self) { date in
                    Section(header: Text(dateFormatter.string(from: date))) {
                        ForEach(groupedByDate[date] ?? [], id: \.self) { savedCurrency in
                            HStack(spacing: .zero) {
                                HStack {
                                    if let initialCurrency = savedCurrency.initialCurrency, let secondaryCurrency = savedCurrency.secondaryCurrency {
                                        Text("\(initialCurrency) to \(secondaryCurrency)")
                                            .bold()
                                    }
                                }
                                Spacer()
                                HStack {
                                    if let initialAmount = savedCurrency.initialAmount, let secondaryAmount = savedCurrency.secondaryAmount {
                                        Text(initialAmount)
                                            .lineLimit(1)
                                        Divider().frame(height: 20)
                                        Text(secondaryAmount)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Conversion History")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
