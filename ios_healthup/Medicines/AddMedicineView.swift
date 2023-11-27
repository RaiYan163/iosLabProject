import SwiftUI
import FirebaseDatabase

struct AddMedicineView: View {
    @State private var md_name: String = ""
    @State private var intakeFrequency: Int = 0
    @State private var timeInputs: [Date] = Array(repeating: Date(), count: 0)
    @State private var shortNote: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let user_id: String = "imran"

    var body: some View {
        List {
            Section(header: Text("Medicine Details")) {
                TextField("Medicine Name", text: $md_name)
                TextField("Note (Optional)", text: $shortNote)
            }

            Section(header: Text("Intake frequency per day")) {
                TextField("Enter a number", text: Binding(
                    get: { String(intakeFrequency) },
                    set: {
                        if let newValue = Int($0) {
                            intakeFrequency = newValue
                            timeInputs = Array(repeating: Date(), count: intakeFrequency)
                        }
                    }
                ))
                .keyboardType(.numberPad)
            }

            Section(header: Text("Intake times")) {
                ForEach(0..<intakeFrequency, id: \.self) { index in
                    DatePicker("Time \(index + 1)", selection: $timeInputs[index], displayedComponents: .hourAndMinute)
                }
            }
            
            Section {
                Button(action: {
                    saveToFirebase()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
            }
        }
        .navigationBarTitle("Medicine List")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func saveToFirebase() {
        let ref = Database.database().reference()
        let medicinesRef = ref.child("medicines").child(user_id).childByAutoId()

        let medicineData: [String: Any] = [
            "md_name": md_name,
            "intakeFrequency": intakeFrequency,
            "shortNote": shortNote,
            "times": timeInputs.map { $0.description } // Make sure this format matches what you expect in Firebase
        ]

        medicinesRef.setValue(medicineData) { error, reference in
            if let error = error {
                showAlert(message: "Could not save medicine: \(error.localizedDescription)")
            } else {
                NotificationManager.shared.scheduleNotification(medicineName: self.md_name, intakeTimes: self.timeInputs)
                showAlert(message: "Medicine saved successfully!")
            }
        }
    }
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct AddMedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineView()
    }
}
