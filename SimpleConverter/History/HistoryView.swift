import SwiftUI

struct HistoryView: View {
    
    @State var fruits: [String] = ["Apple"]
    
    var body: some View {
        ScrollView {
            NavigationView {
                List {
                    Section(header: Text("Today")) {
                        ForEach(fruits, id: \.self) { fruit in
                            Text(fruit)
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
