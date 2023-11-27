import SwiftUI

// Define the Gender enum
enum Gender {
    case male, female
}

// Define the BMICalculatorView View
struct BMICalculatorView: View {
    @State private var selectedGender: Gender = .male
    @State private var height: Double = 176
    @State private var weight: Int = 78
    @State private var age: Int = 23
    @State private var navigateToBMIResult: Bool = false
    @State private var navigateToBMRResult: Bool = false

    var body: some View {
        VStack {
            HStack {
                GenderSelectionButton(gender: .male, selectedGender: $selectedGender)
                GenderSelectionButton(gender: .female, selectedGender: $selectedGender)
            }

            Slider(value: $height, in: 100...250, step: 1)
                .padding()
            Text("Height: \(Int(height)) cm")

            HStack {
                Stepper("Weight: \(weight) kg", value: $weight, in: 1...300)
                Stepper("Age: \(age)", value: $age, in: 1...120)
            }

            HStack {
                Button("Calc BMI") {
                    navigateToBMIResult = true
                }
                .buttonStyle(RedButtonStyle())
                .background(
                    NavigationLink(
                        destination: BMIResultView(bmiValue: calculateBMI()),
                        isActive: $navigateToBMIResult
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )

                Spacer() // Add space between the buttons

                Button("Calc BMR") {
                    navigateToBMRResult = true
                }
                .buttonStyle(RedButtonStyle())
                .background(
                    NavigationLink(
                        destination: BMRResultView(bmrValue: calculateBMR()),
                        isActive: $navigateToBMRResult
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding()
    }
    
    func calculateBMI() -> Double {
        let heightInMeters = height / 100
        return Double(weight) / (heightInMeters * heightInMeters)
    }
    
    func calculateBMR() -> Double {
        if selectedGender == .male {
            return 88.362 + (13.397 * Double(weight)) + (4.799 * height) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * Double(weight)) + (3.098 * height) - (4.330 * Double(age))
        }
    }
}


struct BMIResultView: View {
    @Environment(\.presentationMode) var presentationMode
    let bmiValue: Double
    
    var body: some View {
        VStack(spacing: 20) {
            // ... your existing code ...
            Image(systemName: "figure.walk")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Your BMI is:")
                .font(.title)
                .fontWeight(.medium)
            
            Text(String(format: "%.2f", bmiValue))
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(bmiValue < 25 ? .green : .orange)
            
            Button("Back to Calculator") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .navigationBarTitle("BMI Result", displayMode: .inline)
    }
}

struct BMRResultView: View {
    @Environment(\.presentationMode) var presentationMode
    let bmrValue: Double
    
    var body: some View {
        VStack(spacing: 20) {
            // ... your existing code ...
            Image("bmi")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
            
            Text("Your BMR is:")
                .font(.title)
                .fontWeight(.medium)
            
            Text(String(format: "%.0f", bmrValue))
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.purple)
            
            Button("Back to Calculator") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(10)
        }
        .padding()
        .navigationBarTitle("BMR Result", displayMode: .inline)
    }
}



// Define the GenderSelectionButton View
struct GenderSelectionButton: View {
    let gender: Gender
    @Binding var selectedGender: Gender

    var body: some View {
        Button(action: {
            self.selectedGender = gender
        }) {
            VStack {
                Image(systemName: gender == .male ? "person" : "person.fill")
                    .font(.largeTitle)
                    .foregroundColor(gender == selectedGender ? .blue : .gray)
                Text(gender == .male ? "Male" : "Female")
                    .foregroundColor(gender == selectedGender ? .blue : .gray)
            }
            .padding()
            .background(gender == selectedGender ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

// Define the BMICalculatorView_Previews View
struct BMICalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        BMICalculatorView()
    }
}
struct RedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
