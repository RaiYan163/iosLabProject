import SwiftUI
import Firebase // Import Firebase

struct SignInScreenView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToSignUp = false
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()

                VStack {
                    Text("Sign IN")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)

                   

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

                    PrimaryButton(title: "Sign In") {
                        signUpUser()
                    }
                    NavigationLink(destination: SignUpScreenView(), isActive: $navigateToSignUp) {
                        PrimaryButton(title: "Sign Up Instead") {
                            self.navigateToSignUp = true
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
    }
}

struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView()
    }
}
