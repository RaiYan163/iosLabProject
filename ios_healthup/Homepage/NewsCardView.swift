import SwiftUI
import SafariServices

struct NewsCardView: View {
    let article: NewsArticle
    @State private var showSafari = false

    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = article.urlToImage {
                AsyncImageView(urlString: imageURL)
                    .aspectRatio(contentMode: .fill)
            }
            Text(article.title)
                .font(.headline)
            Text(article.description ?? "")
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        // Present the SafariView when showSafari is true
        .sheet(isPresented: $showSafari) {
            if let url = URL(string: article.url) {
                SafariView(url: url)
            }
        }
        // Make the entire card tappable and set showSafari to true when tapped
        .onTapGesture {
            showSafari = true
        }
    }
}
