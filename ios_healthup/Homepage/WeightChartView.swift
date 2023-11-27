import SwiftUI
import FirebaseDatabase

// Declare WeightEntry struct here or in a shared file
struct WeightEntry: Identifiable {
    let id: String
    let date: Date
    let weight: Double

    init(date: Date, weight: Double) {
        self.id = UUID().uuidString
        self.date = date
        self.weight = weight
    }
}

struct WeightChartView: View {
    @State private var weightData: [WeightEntry] = []

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    for (index, entry) in weightData.enumerated() {
                        let x = CGFloat(index) * (geometry.size.width / CGFloat(weightData.count - 1))
                        let y = CGFloat(entry.weight) / CGFloat(maxWeight()) * geometry.size.height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: geometry.size.height - y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height - y))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .frame(height: 200)
            .padding()

            List {
                ForEach(weightData) { entry in
                    Text("\(entry.date): \(entry.weight) kg")
                }
            }
            .onAppear {
                fetchWeightDataFromFirebase()
            }
        }
        .navigationBarTitle("Weight Chart")
    }

    func fetchWeightDataFromFirebase() {
        let user_id: String = "imran" // Replace with the actual user ID
        let ref = Database.database().reference().child("weights").child(user_id)

        ref.observe(.value) { snapshot in
            var weights: [WeightEntry] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    if let dateString = value["timestamp"] as? TimeInterval,
                       let weight = value["weight"] as? Double {
                        let date = Date(timeIntervalSince1970: dateString / 1000)
                        let entry = WeightEntry(date: date, weight: weight)
                        weights.append(entry)
                    }
                }
            }

            self.weightData = weights.sorted(by: { $0.date < $1.date })

            // Print statements for debugging
            print("Fetched data from Firebase:")
            for entry in self.weightData {
                print("\(entry.date): \(entry.weight) kg")
            }
        }
    }

    // Helper function to find the maximum weight for scaling the chart
    func maxWeight() -> Double {
        return weightData.map { $0.weight }.max() ?? 1.0
    }
}

struct WeightChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeightChartView()
    }
}

