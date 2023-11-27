import SwiftUI
import FirebaseDatabase
import Firebase

struct WeightInputView: View {
    @State private var weight: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let user_id: String = "imran"

    var body: some View {
        List {
            Section(header: Text("Enter Your Daily Weight")) {
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button(action: {
                    saveWeightToFirebase()
                }) {
                    Text("Save Weight")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .navigationBarTitle("Weight Tracker")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        NavigationLink(destination: WeightChartView()) {
            HomeSquareee(color: .green, imageName: "chart.bar.fill", title: "Show Chart")
        }

    }

    func saveWeightToFirebase() {
        guard let weightValue = Double(weight) else {
            showAlert(message: "Please enter a valid weight")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateIdentifier = dateFormatter.string(from: Date())
        
        let ref = Database.database().reference()
        let weightRef = ref.child("weights").child(user_id).child(dateIdentifier)
        
        let weightData: [String: Any] = [
            "weight": weightValue,
            "timestamp": ServerValue.timestamp()
        ]

        weightRef.setValue(weightData) { error, _ in
            if let error = error {
                showAlert(message: "Could not save weight: \(error.localizedDescription)")
            } else {
                showAlert(message: "Weight saved successfully!")
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct WeightInputView_Previews: PreviewProvider {
    static var previews: some View {
        WeightInputView()
    }
}
struct HomeSquareee: View {
    var color: Color
    var imageName: String
    var title: String

    var body: some View {
        
             // Add spacer to center content vertically
        HStack{
            Image(systemName: imageName)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            
            Spacer() // Add spacer to center content vertically
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(color)
        .cornerRadius(15)
        .padding()
        Spacer()
    }
}
