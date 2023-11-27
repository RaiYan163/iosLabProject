//
//  Apiservice.swift
//  ios_healthup
//
//  Created by kuet on 26/11/23.
//
import Foundation
import Combine

class NewsApiService {
    static let shared = NewsApiService()
    private let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=8bf18064f69c4bacaccd0f585d4b2e99")!

    func fetchNews() -> AnyPublisher<NewsResponse, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response in
                guard let httpResponse = response.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
