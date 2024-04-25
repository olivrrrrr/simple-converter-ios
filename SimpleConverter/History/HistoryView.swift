import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()

    var body: some View {
        List {
            ForEach(viewModel.groupByDateAndSort(), id: \.0) { tuple in
                let (date, currencies) = tuple
                
                Section(header: Text(viewModel.getFormattedDate(date: date))) {
                    ForEach(currencies, id: \.self) { savedCurrency in
                        HStack(spacing: .zero) {
                            typeOfConversion(savedCurrency)
                            conversionAmount(savedCurrency)
                        }
                    }
                }
            }
        }
        .navigationTitle(HistoryViewModel.Constants.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - VIEWS
    @ViewBuilder
    func typeOfConversion(_ savedCurrency: Conversion) -> some View {
        HStack {
            if let initialCurrency = savedCurrency.initialCurrency,
               let secondaryCurrency = savedCurrency.secondaryCurrency {
                Text("\(initialCurrency) to \(secondaryCurrency)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    func conversionAmount(_ savedCurrency: Conversion) -> some View {
        HStack {
            if let initialAmount = savedCurrency.initialAmount,
               let secondaryAmount = savedCurrency.secondaryAmount {
                Text(initialAmount)
                    .lineLimit(1)
                
                Divider()
                    .frame(height: 20)
                
                Text(secondaryAmount)
                    .lineLimit(1)
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
