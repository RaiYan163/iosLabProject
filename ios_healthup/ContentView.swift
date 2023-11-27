import SwiftUI
import Combine


struct ContentView: View {
    var body: some View {
        WelcomeScreenView()
    }
}


struct PrimaryButton: View {
    var title: String
    var action: () -> Void // Closure to handle button tap

    var body: some View {
        Button(action: {
            self.action() // Execute the closure when the button is tapped
        }) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white) // Text color
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue) // Use a standard SwiftUI color
                .cornerRadius(50)
        }
    }
}




