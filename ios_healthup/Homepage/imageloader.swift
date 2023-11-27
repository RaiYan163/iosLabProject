//
//  imageloader.swift
//  ios_healthup
//
//  Created by kuet on 26/11/23.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func load(fromURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}

struct AsyncImageView: View {
    @StateObject private var loader = ImageLoader()
    let urlString: String

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray // Placeholder for loading or failed load
            }
        }
        .onAppear {
            loader.load(fromURLString: urlString)
        }
    }
}
