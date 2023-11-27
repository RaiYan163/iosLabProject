//
//  MedicineListView.swift
//  ios_healthup
//
//  Created by kuet on 5/11/23.
//

import SwiftUI
import FirebaseDatabase

struct Medicine: Identifiable {
    let id: String
    let md_name: String
    let intakeFrequency: Int
    let shortNote: String
    let times: [String]
}

struct MedicineListView: View {
    @State private var medicines: [Medicine] = []

    var body: some View {
        List {
            ForEach(medicines) { medicine in
                VStack (alignment: .leading, spacing: 10){
                    VStack(alignment: .leading, spacing: 2) {
                        Text(medicine.md_name)
                            .font(.headline)
                        Text("Intake Frequency: \(medicine.intakeFrequency)")
                        Text("Short Note: \(medicine.shortNote)")
                        Text("Times: \(medicine.times.joined(separator: ", "))")
                    }
                    .frame(height: 70)
                    .padding(10)

                    HStack {
                            Spacer()
                        Button(action: {
                                        deleteMedicineFromFirebase(medicine: medicine)
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                    }
                                }
                            
                }
            }
        }
        .onAppear {
            fetchMedicinesFromFirebase()
        }
        .navigationBarTitle("Medicine List")
        
        Spacer()
        
        NavigationLink(destination: AddMedicineView()) {
            HomeSquaree(color: .red, imageName: "plus.circle.fill", title: "Add Medicine")
        }
    }

    func fetchMedicinesFromFirebase() {
        let ref = Database.database().reference()
        let userId = "imran"
        let medicinesRef = ref.child("medicines").child(userId)

        medicinesRef.observe(.value) { snapshot in
            var medicinesList: [Medicine] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    if let id : Optional = snap.key,
                       let md_name = value["md_name"] as? String,
                       let intakeFrequency = value["intakeFrequency"] as? Int,
                       let shortNote = value["shortNote"] as? String,
                       let times = value["times"] as? [String] {
                        let medicine = Medicine(id: id!, md_name: md_name, intakeFrequency: intakeFrequency, shortNote: shortNote, times: times)
                        medicinesList.append(medicine)
                    }
                }
            }

            self.medicines = medicinesList
        }
    }

    func deleteMedicineFromFirebase(medicine: Medicine) {
        let ref = Database.database().reference()
        let userId = "imran" // Replace with the actual user ID
        let medicineRef = ref.child("medicines").child(userId).child(medicine.id)

        medicineRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting medicine: \(error)")
            }
        }
    }
}

struct HomeSquaree: View {
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


struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView()
    }
}
