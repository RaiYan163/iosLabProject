//
//  apimodel.swift
//  ios_healthup
//
//  Created by kuet on 26/11/23.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [NewsArticle]
}

struct NewsArticle: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
}
