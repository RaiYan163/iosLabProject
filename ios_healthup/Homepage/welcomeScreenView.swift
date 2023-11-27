import SwiftUI

struct WelcomeScreenView: View {
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("HealthUp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Image("home_cover")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 200)

                    Spacer()

                    NavigationLink(
                        destination: SignInScreenView().navigationBarHidden(true),
                        label: {
                            Text("Sign In")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0.0, y: 5)
                                .padding(.vertical)
                        })
                        .navigationBarHidden(true)

                   
                    

                    
                }
                .padding()
            }
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
