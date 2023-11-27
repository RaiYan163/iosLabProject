import SwiftUI
import Firebase // Import Firebase
import FirebaseDatabase

struct SignUpScreenView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToSignIn = false
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()

                VStack {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)

                    TextField("Full Name", text: $name)
                        .font(.title3)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .padding(.vertical)

                    TextField("Email Address", text: $email)
                        .font(.title3)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .padding(.vertical)

                    SecureField("Password", text: $password)
                        .font(.title3)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .padding(.vertical)

                    PrimaryButton(title: "Sign Up") {
                        signUpUser()
                    }
                    NavigationLink(destination: SignInScreenView(), isActive: $navigateToSignIn) {
                        PrimaryButton(title: "Sign In") {
                            self.navigateToSignIn = true
                        }
                                        }
                }

                Spacer()
                Divider()
                Spacer()
                Text("Read our Terms & Conditions.")
                Spacer()
            }
            .padding()
        }
    }

    private func signUpUser() {
        // Add Firebase sign-up logic here
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                   guard let strongSelf = self else { return }

                   if let error = error {
                       print("Error creating user: \(error.localizedDescription)")
                       return
                   }

                   guard let user = authResult?.user else {
                       print("User creation error: No user data found")
                       return
                   }

                   // Step 2: Save additional details like the full name
                   strongSelf.saveUserDetails(user: user)
               }
    }
    private func saveUserDetails(user: User) {
        // Set up Firestore or Realtime Database instance
        let db = Firestore.firestore()
        
        // Create a user data dictionary
        let userData = [
            "fullName": name,
            "email": email
            // Add more fields as needed
        ]
        
        // Save user data to Firestore
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error saving user details: \(error.localizedDescription)")
            } else {
                print("User details saved successfully")
                // Optionally, navigate to another view or show success message
            }
        }
    }
}

struct SignUpScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreenView()
    }
}
