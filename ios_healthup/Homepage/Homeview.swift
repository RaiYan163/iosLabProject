import SwiftUI
import Combine

struct HomePageView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Welcome to HealthUp!")
                                    .font(.title)
                                    .padding()
                NotificationView()

                // Water Intake Area
                WaterIntakeView()

                // Main Content
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    NavigationLink(destination: MedicineListView()) {
                        HomeSquare(color: .blue, imageName: "pill", title: "Medicines")
                    }

                    NavigationLink(destination: ExerciseView()) {
                        HomeSquare(color: .green, imageName: "heart.fill", title: "Exercise")
                    }

                    NavigationLink(destination: BMICalculatorView()) {
                        HomeSquare(color: .orange, imageName: "waveform.path.ecg", title: "BMR & BMI")
                    }

                    NavigationLink(destination: WeightInputView()) {
                        HomeSquare(color: .purple, imageName: "chart.bar.fill", title: "Reports")
                    }
                    
                    NavigationLink(destination: NewsView()) {
                        HomeSquare(color: .purple, imageName: "newspaper", title: "Health News")
                    }
                   
                    
                    
                    
                    
                }
                
                

                Spacer()
                
            }
            .padding()
        }
    }
}

struct NotificationView: View {
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(.black)

            Text("Time to take medicine")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.orange)
    }
}

struct NewsView: View {
    @State private var articles = [NewsArticle]()
    @State private var isLoading = false
    @State private var cancellables = Set<AnyCancellable>()  // Correctly using @State

    var body: some View {
        NavigationView {
            List(articles, id: \.id) { article in
                NewsCardView(article: article)
            }
            .navigationBarTitle("Health News")
            .onAppear {
                isLoading = true
                NewsApiService.shared.fetchNews()
                    .sink(receiveCompletion: { completion in
                        self.isLoading = false
                        if case .failure(let error) = completion {
                            print(error.localizedDescription)
                        }
                    }, receiveValue: { response in
                        self.articles = response.articles
                    })
                    .store(in: &cancellables)
            }
        }
    }
}


struct WaterIntakeView: View {
    @State private var waterIntakeCount: Int = 0
    

    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .padding()

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Button(action: {
                        decreaseWaterIntake()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Text("\(waterIntakeCount)")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20) // Adjust the trailing space as needed

                    Spacer()

                    Button(action: {
                        increaseWaterIntake()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.green)
        .cornerRadius(15)

    }

    func increaseWaterIntake() {
        waterIntakeCount += 1
    }

    func decreaseWaterIntake() {
        if waterIntakeCount > 0 {
            waterIntakeCount -= 1
        }
    }
}

struct newsApiView: View {
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)

            Text("Health News Update")
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding()
        }
        
        .frame(maxWidth: .infinity)
        .background(Color(red: 132/255, green: 3/255, blue: 252/255))
    }
    
}
struct HomeSquare: View {
    var color: Color
    var imageName: String
    var title: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding()

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .cornerRadius(15)
    }
}

struct ExerciseView: View {
    var body: some View {
        Text("Exercise Page")
            .navigationTitle("Exercise")
    }
}

struct NutritionView: View {
    var body: some View {
        Text("Nutrition Page")
            .navigationTitle("Nutrition")
    }
}

struct ReportsView: View {
    var body: some View {
        Text("Reports Page")
            .navigationTitle("Reports")
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}





